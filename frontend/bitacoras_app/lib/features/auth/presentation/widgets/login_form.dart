import 'package:bitacoras_app/shared/exports.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    this.emailError,
    this.passwordError,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo Institucional',
            hintText: 'ejemplo@est.itstena.edu.ec',
            prefixIcon: const Icon(Icons.email_outlined),
            errorText: emailError,
          ),
        ),
        AppSizes.gapV16,
        TextFormField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            errorText: passwordError,
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