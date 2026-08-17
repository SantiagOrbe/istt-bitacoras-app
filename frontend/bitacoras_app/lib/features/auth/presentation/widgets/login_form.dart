import 'package:flutter/material.dart';
import 'package:bitacoras_app/core/widgets/buttons/custom_button.dart';
import 'package:bitacoras_app/shared/exports.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Correo Institucional',
            hintText: 'ejemplo@itst.edu.ec',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        AppSizes.gapV16,
        TextField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: onTogglePasswordVisibility,
            ),
          ),
        ),
        AppSizes.gapV24,
        CustomButton(
          isFullWidth: true,
          text: 'Iniciar Sesión',
          icon: Icons.login_rounded,
          isLoading: isLoading,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}