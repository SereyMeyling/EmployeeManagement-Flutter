import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'api_constants.dart';
import 'app_exception.dart';
import 'token_storage.dart';
import '../data/models/token_model.dart';

/// Single HTTP entry point. Adds the JWT, refreshes it on 401 (one refresh at
/// a time; concurrent requests wait on the same Completer) and unwraps the
/// backend's `{code, message, messageKh, data}` envelope.
class DioClient {
  late final Dio dio;
  Completer<bool>? _refreshing;
  void Function()? onSessionExpired;

  DioClient() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = TokenStorage.accessToken;

        if (token != null && !_isAuthCall(options.path)) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        debugPrint('API REQUEST: ${options.method} ${options.path}');
        debugPrint(
          'AUTHORIZATION HEADER EXISTS: '
          '${options.headers.containsKey('Authorization')}',
        );

        handler.next(options);
      },
      onError: (e, handler) async {
        final req = e.requestOptions;
        // Never refresh for login/refresh calls themselves (avoids loops).
        final canRefresh = e.response?.statusCode == 401 &&
            !_isAuthCall(req.path) &&
            req.extra['retried'] != true &&
            (TokenStorage.refreshToken ?? '').isNotEmpty;

        if (canRefresh) {
          final ok = await _refreshToken();
          if (ok) {
            req.extra['retried'] = true;
            req.headers['Authorization'] = 'Bearer ${TokenStorage.accessToken}';
            try {
              return handler.resolve(await dio.fetch(req));
            } on DioException catch (err) {
              return handler.reject(err);
            }
          } else {
            onSessionExpired?.call();
          }
        }
        handler.next(e);
      },
    ));
  }

  bool _isAuthCall(String path) =>
      path.contains(ApiConstants.login) || path.contains(ApiConstants.refresh);

  Future<bool> _refreshToken() {
    if (_refreshing != null) return _refreshing!.future;
    final completer = Completer<bool>();
    _refreshing = completer;

    () async {
      try {
        final res = await Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)).post(
          ApiConstants.refresh,
          data: {'refreshToken': TokenStorage.refreshToken},
        );
        final data = unwrap(res.data);
        final token =
            TokenModel.fromJson(Map<String, dynamic>.from(data as Map));
        await TokenStorage.save(
          access: token.accessToken,
          refresh: token.refreshToken ?? TokenStorage.refreshToken,
        );
        completer.complete(true);
      } catch (_) {
        completer.complete(false);
      } finally {
        _refreshing = null;
      }
    }();

    return completer.future;
  }

  static dynamic unwrap(dynamic body) {
    if (body is Map && body.containsKey('data')) return body['data'];
    return body;
  }

  static List<Map<String, dynamic>> extractList(dynamic d) {
    if (d is List) {
      return d
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (d is Map) {
      for (final k in [
        'content',
        'list',
        'items',
        'records',
        'data',
        'products',
        'users'
      ]) {
        if (d[k] is List) return extractList(d[k]);
      }
    }
    return [];
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final res = await dio.post(path, data: data ?? {});
      return unwrap(res.data);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}
