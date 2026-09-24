import '../../auth.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      'usuarios/login/',
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de autenticación no es válida.');
    }
    return response;
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await apiClient.post(
      'register/',
      body: {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      },
      requiresAuth: false,
    );
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await apiClient.get('usuarios/perfil/');
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del perfil no es válida.');
    }
    return response;
  }
}
