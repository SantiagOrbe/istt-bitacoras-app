import 'auth.dart';

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
