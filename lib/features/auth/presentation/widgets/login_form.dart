import 'package:flutter/material.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/inputs/custom_text_field.dart';
import '../../../../core/widgets/inputs/password_text_field.dart';
import 'login_controller.dart'; // Importamos el controlador

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool _isLoading = false;
  late LoginController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador pasándole las dependencias necesarias
    _controller = LoginController(
      context: context,
      userController: userController,
      passwordController: passwordController,
      onLoadingChanged: (loading) {
        setState(() => _isLoading = loading);
      },
    );
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: userController,
          label: 'Correo Institucional',
          prefixIcon: Icons.email_outlined,
        ),

        const SizedBox(height: 20),

        PasswordTextField(
          controller: passwordController,
        ),

        const SizedBox(height: 30),

        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomButton(
                text: 'Ingresar',
                onPressed: _controller.login, // Delegamos la acción al controlador
              ),
      ],
    );
  }
}