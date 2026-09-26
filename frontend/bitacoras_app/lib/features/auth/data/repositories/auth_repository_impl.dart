import '../../auth.dart';


class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<UsuarioModel?> iniciarSesion({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Por favor ingrese correo y contraseña.');
    }

    final response = await remoteDataSource.iniciarSesion(
      email: email,
      password: password,
    );
    final token = response['access'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('La respuesta no contiene un token de acceso.');
    }

    await tokenStorage.deleteToken();
    await tokenStorage.saveToken(token);
    return obtenerUsuarioActual();
  }

  @override
  Future<void> registrarUsuario({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return remoteDataSource.registrarUsuario(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Future<void> cerrarSesion() async {
    await tokenStorage.deleteToken();
  }

  @override
  Future<UsuarioModel?> obtenerUsuarioActual() async {
    final token = await tokenStorage.getToken();
    if (token == null || token.isEmpty) return null;
    final profile = await remoteDataSource.obtenerPerfil();
    return UsuarioModel.fromJson(profile);
  }
}
