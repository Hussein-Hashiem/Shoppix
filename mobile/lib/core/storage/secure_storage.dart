import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  static const _key = 'auth_token';

  final FlutterSecureStorage _storage;
  SecureTokenStorage(this._storage);

  Future<String?> readToken() => _storage.read(key: _key);

  Future<void> saveToken(String token) =>
      _storage.write(key: _key, value: token);

  Future<void> clear() => _storage.delete(key: _key);
}
