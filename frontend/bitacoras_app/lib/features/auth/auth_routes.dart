import 'auth.dart';

abstract class AuthRoutes {
  AuthRoutes._();

  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.inicioSesion,
          builder: (context, state) => LoginScreen(
            authRepository: context.read<IAuthRepository>(),
          ),
        ),
        GoRoute(
          path: AppRoutes.registro,
          builder: (context, state) => RegisterScreen(
            authRepository: context.read<IAuthRepository>(),
          ),
        ),
      ];
}
