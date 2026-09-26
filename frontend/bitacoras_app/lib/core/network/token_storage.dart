import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageException implements Exception {
  final String message;

  const TokenStorageException(this.message);

  @override
  String toString() => 'Error de almacenamiento: $message';
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
    } catch (_) {
      throw const TokenStorageException(
        'No se pudo guardar la sesión. Inténtalo de nuevo.',
      );
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (_) {
      throw const TokenStorageException(
        'No se pudo leer la sesión almacenada.',
      );
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (_) {
      throw const TokenStorageException(
        'No se pudo cerrar la sesión correctamente.',
      );
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (_) {
      throw const TokenStorageException(
        'No se pudo limpiar el almacenamiento del dispositivo.',
      );
    }
  }
}