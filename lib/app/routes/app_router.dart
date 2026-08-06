import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/data/repositories/fake_admin_repository.dart';
import 'package:bitacoras_app/features/attendance/presentation/screens/register_exit_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login, 
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => LoginScreen(
        authRepository: AuthRepositoryImpl(),
      ),
    ),
    GoRoute(
      path: AppRoutes.studentHome,
      builder: (context, state) => const StudentHome(),
    ),
    GoRoute(
      path: AppRoutes.registerExitAttendance,
      builder: (context, state) => RegisterExitScreen(
        currentUser: FakeUserRepository.student,
        attendanceRepository: FakeAttendanceRepository(),
      ), 
    ),  
    GoRoute(
      path: AppRoutes.attendance,
      builder: (context, state) => RegisterAttendanceScreen(
        currentUser: FakeUserRepository.student,
        attendanceRepository: FakeAttendanceRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.registerActivity,
      builder: (context, state) => RegisterActivityScreen(
        currentUser: FakeUserRepository.student,
        attendanceRepository: FakeAttendanceRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => HistoryScreen(
        currentUser: FakeUserRepository.student,
        attendanceRepository: FakeAttendanceRepository()
      ),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => ReportsScreen(
        currentUser: FakeUserRepository.student,
        attendanceRepository: FakeAttendanceRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(
        currentUser: FakeUserRepository.student,
      ),
    ),
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (context, state) => const AdminHome(), 
    ),
    GoRoute(
      path: AppRoutes.userManagement,
      builder: (context, state) => UserManagementScreen(
        currentUser: FakeUserRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.careerPeriod,
      builder: (context, state) => CareerPeriodScreen(
        currentUser: FakeUserRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.teacherHome,
      builder: (context, state) => const TeacherHome(), 
    ),
    GoRoute(
      path: AppRoutes.academicTutorHome,
      builder: (context, state) => const AcademicTutorHome(), 
    ),
    GoRoute(
      path: AppRoutes.companyTutorHome,
      builder: (context, state) => const CompanyTutorHome(), 
    ),
    GoRoute(
      path: AppRoutes.coordinatorHome,
      builder: (context, state) => const CoordinatorHome(), 
    ),
    GoRoute(
      path: AppRoutes.practiceManagerHome,
      builder: (context, state) => const PracticeManagerHome(), 
    ),
  ],
);