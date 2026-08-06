import 'package:bitacoras_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bitacoras_app/features/auth/presentation/screens/login_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';

abstract class AuthRoutes {
  AuthRoutes._(); 

  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => LoginScreen(
            authRepository: AuthRepositoryImpl(),
          ),
        ),
      ];
}