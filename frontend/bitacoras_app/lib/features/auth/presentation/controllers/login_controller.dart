import 'package:bitacoras_app/core/network/api_client.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../domain/repositories/i_auth_repository.dart';

class LoginController extends ChangeNotifier {
  final IAuthRepository repository;

  LoginController({required this.repository});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;
  String? errorMessage;
  String? emailError;
  String? passwordError;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<UsuarioModel?> submitLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    emailError = null;
    passwordError = null;
    errorMessage = null;

    if (email.isEmpty) {
      emailError = 'Ingrese su correo institucional.';
    } else if (!email.toLowerCase().endsWith('@est.itstena.edu.ec')) {
      emailError = 'Use un correo @est.itstena.edu.ec.';
    }
    if (password.trim().isEmpty) {
      passwordError = 'Ingrese su contraseña.';
    }
    if (emailError != null || passwordError != null) {
      notifyListeners();
      return null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await repository.login(
        email: email,
        password: password,
      );
      
      isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      isLoading = false;
      if (e is ApiException && e.body is Map<String, dynamic>) {
        final body = e.body as Map<String, dynamic>;
        emailError = _fieldError(body['email']);
        passwordError = _fieldError(body['password']);
        errorMessage = _fieldError(body['detail']) ??
            _fieldError(body['non_field_errors']);
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      notifyListeners();
      return null;
    }
  }

  String? _fieldError(dynamic value) {
    if (value is List && value.isNotEmpty) return value.first.toString();
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}