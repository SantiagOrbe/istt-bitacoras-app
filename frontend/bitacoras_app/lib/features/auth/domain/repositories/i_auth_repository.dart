import '../../auth.dart';

abstract class IAuthRepository {
  Future<UsuarioModel?> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<void> logout();

  Future<UsuarioModel?> getCurrentUser();
}
