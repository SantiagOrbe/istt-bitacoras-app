import '../../auth.dart';


class LoginScreen extends StatefulWidget {
  final IAuthRepository authRepository;

  const LoginScreen({super.key, required this.authRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(repositorio: widget.authRepository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final user = await _controller.iniciarSesion();

    if (!mounted) return;

    if (user != null) {
      context.read<AuthSession>().setUser(user);
      switch (user.role) {
        case RolUsuarioModel.student:
          context.go(AppRoutes.studentHome);
          break;
        case RolUsuarioModel.academicTutor:
          context.go(AppRoutes.academicTutorHome);
          break;
        case RolUsuarioModel.companyTutor:
          context.go(AppRoutes.companyTutorHome);
          break;
        case RolUsuarioModel.admin:
          context.go(AppRoutes.adminHome);
          break;
        case RolUsuarioModel.practiceManager:
          context.go(AppRoutes.practiceManagerHome);
          break;
        case RolUsuarioModel.coordinator:
          context.go(AppRoutes.coordinatorHome);
          break;
        default:
          context.go(AppRoutes.studentHome);
      }
    } else if (_controller.mensajeError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.mensajeError!,
            style: AppTextStyles.body.copyWith(color: AppColors.surface),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoginHeader(),
                    AppSizes.gapV32,
                    LoginForm(
                      controladorCorreo: _controller.controladorCorreo,
                      controladorContrasena: _controller.controladorContrasena,
                      mostrarContrasena: _controller.mostrarContrasena,
                      estaCargando: _controller.estaCargando,
                      errorCorreo: _controller.errorCorreo,
                      errorContrasena: _controller.errorContrasena,
                      alAlternarContrasena:
                          _controller.alternarVisibilidadContrasena,
                      alEnviar: _handleLogin,
                    ),
                    AppSizes.gapV16,
                    TextButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: const Text('¿No tienes cuenta? Regístrate aquí'),
                    ),
                    const SizedBox(height: 24),
                    const LoginFooter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
