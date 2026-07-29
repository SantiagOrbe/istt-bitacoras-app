import 'package:go_router/go_router.dart';
import 'app_routes.dart';

// Importa todas tus pantallas
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/attendance/presentation/screens/register_attendance_screen.dart';
import 'package:bitacoras_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:bitacoras_app/features/attendance/presentation/screens/history_screen.dart';
import 'package:bitacoras_app/features/attendance/presentation/screens/reports_screen.dart';
import 'package:bitacoras_app/features/home/presentation/pages/student_home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login, // O la pantalla de splash / login inicial
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentHome,
      builder: (context, state) => const StudentHome(),
    ),
    GoRoute(
      path: AppRoutes.attendance,
      builder: (context, state) => const RegisterAttendanceScreen(),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

class StudentHomeScreen {
  const StudentHomeScreen();
}