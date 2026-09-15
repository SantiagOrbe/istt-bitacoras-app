import 'package:bitacoras_app/core/network/api_client.dart';
import 'package:bitacoras_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:bitacoras_app/shared/exports.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  final IAuthRepository authRepository;

  const RegisterScreen({
    super.key,
    required this.authRepository,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _serverError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _serverError = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await widget.authRepository.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso. Ahora puedes iniciar sesión.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go(AppRoutes.login);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _serverError = _messageFromError(error);
        _isLoading = false;
      });
    }
  }

  String _messageFromError(Object error) {
    if (error is ApiException && error.body is Map<String, dynamic>) {
      final body = error.body as Map<String, dynamic>;
      for (final field in ['email', 'password', 'confirm_password', 'detail']) {
        final value = body[field];
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String && value.isNotEmpty) return value;
      }
    }
    if (error is ApiException) return error.message;
    return error.toString().replaceAll('Exception: ', '');
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingrese su correo institucional.';
    if (!email.toLowerCase().endsWith('@est.itstena.edu.ec')) {
      return 'Use un correo @est.itstena.edu.ec.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Ingrese una contraseña.';
    if ((value ?? '').length < 8) return 'Use al menos 8 caracteres.';
    return null;
  }

  String? _validateConfirmation(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme su contraseña.';
    if (value != _passwordController.text) return 'Las contraseñas no coinciden.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Registro de Usuarios'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Registro institucional',
                  style: AppTextStyles.title,
                ),
                AppSizes.gapV8,
                Text(
                  'Crea tu cuenta con tu correo institucional.',
                  style: AppTextStyles.body,
                ),
                AppSizes.gapV24,
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Correo Institucional',
                    hintText: 'usuario@est.itstena.edu.ec',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                AppSizes.gapV16,
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                ),
                AppSizes.gapV16,
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  validator: _validateConfirmation,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_isConfirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => setState(
                        () => _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible,
                      ),
                    ),
                  ),
                ),
                if (_serverError != null) ...[
                  AppSizes.gapV16,
                  Text(
                    _serverError!,
                    style: TextStyle(color: AppColors.error),
                  ),
                ],
                AppSizes.gapV24,
                CustomButton(
                  isFullWidth: true,
                  text: 'Registrarme',
                  icon: Icons.person_add_alt_1,
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                AppSizes.gapV8,
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
