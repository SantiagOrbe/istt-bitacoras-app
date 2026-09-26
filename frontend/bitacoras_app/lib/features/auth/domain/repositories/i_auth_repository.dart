import '../../auth.dart';

abstract class IAuthRepository {
  Future<UsuarioModel?> iniciarSesion({
    required String email,
    required String password,
  });

  Future<void> registrarUsuario({
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<void> cerrarSesion();

  Future<UsuarioModel?> obtenerUsuarioActual();
}
