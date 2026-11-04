import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;
  AppException(this.message, {this.statusCode});

  factory AppException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return AppException('Cannot reach the server. Check your connection.');
      default:
        break;
    }
    final code = e.response?.statusCode;
    final body = e.response?.data;
    String? serverMsg;
    if (body is Map) {
      serverMsg = (body['message'] ?? body['description'])?.toString();
    }
    if (code == 401) {
      return AppException(serverMsg ?? 'Invalid credentials or session expired.',
          statusCode: code);
    }
    if (code == 403) {
      return AppException(serverMsg ?? 'You do not have permission (ADMIN required).',
          statusCode: code);
    }
    return AppException(serverMsg ?? 'Something went wrong (${code ?? 'unknown'}).',
        statusCode: code);
  }

  @override
  String toString() => message;
}
