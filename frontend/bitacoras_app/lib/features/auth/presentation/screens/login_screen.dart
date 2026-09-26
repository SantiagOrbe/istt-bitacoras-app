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
          context.go(AppRoutes.inicioEstudiante);
          break;
        case RolUsuarioModel.academicTutor:
          context.go(AppRoutes.inicioTutorAcademico);
          break;
        case RolUsuarioModel.companyTutor:
          context.go(AppRoutes.inicioTutorEmpresarial);
          break;
        case RolUsuarioModel.admin:
          context.go(AppRoutes.inicioAdmin);
          break;
        case RolUsuarioModel.practiceManager:
          context.go(AppRoutes.inicioResponsablePracticas);
          break;
        case RolUsuarioModel.coordinator:
          context.go(AppRoutes.inicioCoordinador);
          break;
        default:
          context.go(AppRoutes.inicioEstudiante);
      }
    } else if (_controller.mensajeError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.mensajeError!,
            style: AppEstiloTexto.body.copyWith(color: AppColores.surface),
          ),
          backgroundColor: AppColores.error,
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
          backgroundColor: AppColores.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppTamanos.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoginHeader(),
                    AppTamanos.gapV32,
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
                    AppTamanos.gapV16,
                    TextButton(
                      onPressed: () => context.push(AppRoutes.registro),
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
