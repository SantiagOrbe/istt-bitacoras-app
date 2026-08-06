import 'package:bitacoras_app/shared/exports.dart';

abstract class IAuthRepository {
  Future<UserModel?> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}