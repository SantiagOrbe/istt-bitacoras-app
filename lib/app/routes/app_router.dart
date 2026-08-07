import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/data/repositories/fake_admin_repository.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/admin_practice_logs_screen.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/career_detail_screen.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/career_management_screen.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/cycle_management_screen.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/period_management_screen.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/parallel_management_screen.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/user_detail_screen.dart';
import 'package:bitacoras_app/features/students/presentation/screens/register_exit_screen.dart';

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
      path: AppRoutes.userDetail,
      builder: (context, state) {
        final user = state.extra as UserModel?;

        return UserDetailScreen(
          user: user ?? FakeUserRepository.admin,
          adminRepository: FakeAdminRepository(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.careerManagement,
      builder: (context, state) => CareerManagementScreen(
        currentUser: FakeUserRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.careerDetail,
      builder: (context, state) {
        final career = state.extra as CareerModel?;

        return CareerDetailScreen(
          currentUser: FakeUserRepository.admin,
          career: career ?? const CareerModel(
            id: '',
            name: '',
            code: '',
            shortName: '',
            description: '',
            modality: '',
            isActive: true,
            totalSemesters: 0,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.careerPeriod,
      builder: (context, state) => CareerPeriodScreen(
        currentUser: FakeUserRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.periodManagement,
      builder: (context, state) => PeriodManagementScreen(
        currentUser: FakeUserRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.cycleManagement,
      builder: (context, state) => CycleManagementScreen(
        currentUser: FakeUserRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.parallelManagement,
      builder: (context, state) => ParallelManagementScreen(
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
    GoRoute(
      path: AppRoutes.adminPracticeLogs,
      builder: (context, state) => const AdminPracticeLogsScreen(currentUser: FakeUserRepository.admin,), 
    ),
  ],
);