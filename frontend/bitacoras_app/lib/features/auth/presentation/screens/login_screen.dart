import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  final IAuthRepository authRepository;

  const LoginScreen({
    super.key,
    required this.authRepository,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(repository: widget.authRepository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 
  Future<void> _handleLogin() async {
    final user = await _controller.submitLogin();

    if (!mounted) return;

    if (user != null) {
      switch (user.role) {
        case RolUsuarioModel.student:
          context.go(AppRoutes.studentHome);
          break;
        case RolUsuarioModel.academicTutor:
          context.go(AppRoutes.academicTutorHome);
          break;
        case RolUsuarioModel.companyTutor:
          context.go(AppRoutes.companyTutorHome);
        case RolUsuarioModel.admin:
          context.go(AppRoutes.adminHome);
        case RolUsuarioModel.practiceManager:
          context.go(AppRoutes.practiceManagerHome);
        case RolUsuarioModel.coordinator:
          context.go(AppRoutes.coordinatorHome);
          break;
        default:
          context.go(AppRoutes.studentHome);
      }
    } else if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.errorMessage!,
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
                      emailController: _controller.emailController,
                      passwordController: _controller.passwordController,
                      isPasswordVisible: _controller.isPasswordVisible,
                      isLoading: _controller.isLoading,
                      onTogglePasswordVisibility: _controller.togglePasswordVisibility,
                      onSubmit: _handleLogin,
                    ),
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