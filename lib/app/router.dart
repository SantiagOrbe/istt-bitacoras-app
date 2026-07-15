import 'package:go_router/go_router.dart';

import '../features/auth/auth_routes.dart';
import 'routes/app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      ...AuthRoutes.routes,
    ],
  );
}