import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  static const _key = 'auth_token';
  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';

  final FlutterSecureStorage _storage;
  SecureTokenStorage(this._storage);

  Future<String?> readToken() => _storage.read(key: _key);

  Future<String?> readName() => _storage.read(key: _nameKey);

  Future<String?> readEmail() => _storage.read(key: _emailKey);

  Future<void> saveToken(String token) =>
      _storage.write(key: _key, value: token);

  Future<void> saveProfile({
    required String name,
    required String email,
  }) async {
    await _storage.write(key: _nameKey, value: name);
    await _storage.write(key: _emailKey, value: email);
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
    await _storage.delete(key: _nameKey);
    await _storage.delete(key: _emailKey);
  }
}
