import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import 'presentation/screens/login_screen.dart';
class AuthRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
      ];
}