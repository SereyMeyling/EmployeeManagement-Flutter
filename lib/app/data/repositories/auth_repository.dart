import '../../core/api_constants.dart';
import '../../core/dio_client.dart';
import '../../core/token_storage.dart';
import '../models/token_model.dart';
import 'package:flutter/foundation.dart';

abstract class AuthRepository {
  Future<void> login(String phoneNumber, String password);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _client;
  AuthRepositoryImpl(this._client);

  @override
  @override
  Future<void> login(String phoneNumber, String password) async {
    final data = await _client.post(
      ApiConstants.login,
      data: {
        'phoneNumber': phoneNumber,
        'password': password,
      },
    );

    // ពិនិត្យថា Backend បញ្ជូន Field អ្វីខ្លះ
    if (data is Map) {
      debugPrint('LOGIN RESPONSE KEYS: ${data.keys.toList()}');
    } else {
      debugPrint('LOGIN RESPONSE TYPE: ${data.runtimeType}');
    }

    final token = TokenModel.fromJson(
      Map<String, dynamic>.from(data as Map),
    );

    await TokenStorage.save(
      access: token.accessToken,
      refresh: token.refreshToken,
      name: phoneNumber,
    );

    // ពិនិត្យថា Token បានរក្សាទុកឬអត់
    debugPrint('ACCESS TOKEN SAVED: ${TokenStorage.hasToken}');
    debugPrint('ACCESS TOKEN LENGTH: ${TokenStorage.accessToken?.length ?? 0}');
    debugPrint(
        'REFRESH TOKEN EXISTS: ${(TokenStorage.refreshToken ?? '').isNotEmpty}');
  }

  @override
  Future<void> logout() async {
    try {
      await _client.post(ApiConstants.logout,
          data: {'refreshToken': TokenStorage.refreshToken});
    } catch (_) {
      // Server-side logout is best effort; always clear locally.
    } finally {
      await TokenStorage.clear();
    }
  }
}
