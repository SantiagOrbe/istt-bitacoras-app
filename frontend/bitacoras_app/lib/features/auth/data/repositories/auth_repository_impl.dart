import '../../auth.dart';


class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<UsuarioModel?> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Por favor ingrese correo y contraseña.');
    }

    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );
    final token = response['access'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('La respuesta no contiene un token de acceso.');
    }

    await tokenStorage.deleteToken();
    await tokenStorage.saveToken(token);
    return getCurrentUser();
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return remoteDataSource.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Future<void> logout() async {
    await tokenStorage.deleteToken();
  }

  @override
  Future<UsuarioModel?> getCurrentUser() async {
    final token = await tokenStorage.getToken();
    if (token == null || token.isEmpty) return null;
    final profile = await remoteDataSource.getProfile();
    return UsuarioModel.fromJson(profile);
  }
}
