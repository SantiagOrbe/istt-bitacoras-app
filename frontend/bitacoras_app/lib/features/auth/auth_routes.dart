import 'package:bitacoras_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:bitacoras_app/features/auth/presentation/screens/login_screen.dart';
import 'package:bitacoras_app/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';
import 'package:provider/provider.dart';

abstract class AuthRoutes {
  AuthRoutes._();

  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => LoginScreen(
            authRepository: context.read<IAuthRepository>(),
          ),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => RegisterScreen(
            authRepository: context.read<IAuthRepository>(),
          ),
        ),
      ];
}