import 'package:get_storage/get_storage.dart';

class TokenStorage {
  static final GetStorage _box = GetStorage();
  static const _access = 'access_token';
  static const _refresh = 'refresh_token';
  static const _name = 'display_name';

  static String? get accessToken => _box.read<String>(_access);
  static String? get refreshToken => _box.read<String>(_refresh);
  static String? get displayName => _box.read<String>(_name);
  static bool get hasToken => (accessToken ?? '').isNotEmpty;

  static Future<void> save({
    required String access,
    String? refresh,
    String? name,
  }) async {
    await _box.write(_access, access);
    if (refresh != null) await _box.write(_refresh, refresh);
    if (name != null) await _box.write(_name, name);
  }

  static Future<void> clear() async {
    await _box.remove(_access);
    await _box.remove(_refresh);
    await _box.remove(_name);
  }
}
