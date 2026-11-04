import '../../core/api_constants.dart';
import '../../core/dio_client.dart';
import '../../core/token_storage.dart';
import '../models/token_model.dart';

abstract class AuthRepository {
  Future<void> login(String phoneNumber, String password);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _client;
  AuthRepositoryImpl(this._client);

  @override
  Future<void> login(String phoneNumber, String password) async {
    // Backend login DTO uses `phoneNumber` (not `username`).
    final data = await _client.post(
      ApiConstants.login,
      data: {'phoneNumber': phoneNumber, 'password': password},
    );
    final token = TokenModel.fromJson(Map<String, dynamic>.from(data as Map));
    await TokenStorage.save(
      access: token.accessToken,
      refresh: token.refreshToken,
      name: phoneNumber,
    );
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
