import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageException implements Exception {
  final String message;

  const TokenStorageException(this.message);

  @override
  String toString() => 'TokenStorageException: $message';
}

class TokenStorage {
  static const _tokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
            );

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      throw TokenStorageException('No se pudo guardar el token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      throw TokenStorageException('No se pudo leer el token: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      throw TokenStorageException('No se pudo eliminar el token: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw TokenStorageException('No se pudo limpiar el almacenamiento: $e');
    }
  }
}