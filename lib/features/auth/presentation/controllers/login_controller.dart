import 'package:flutter/material.dart';
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

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<UserModel?> submitLogin() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.trim().isEmpty || password.trim().isEmpty) {
      errorMessage = 'Por favor complete todos los campos.';
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
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}