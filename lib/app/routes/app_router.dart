import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_carreras_screen.dart';
import 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_estudiantes_screen.dart';
import 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_tutores_screen.dart';
import 'package:bitacoras_app/features/home/presentation/screens/company_tutor_home.dart';
import 'package:bitacoras_app/features/responsable_practicas/data/repositories/fake_responsable_practicas_repository.dart';
import 'package:bitacoras_app/features/responsable_practicas/domain/models/company_model.dart';
import 'package:bitacoras_app/features/responsable_practicas/domain/models/student_assignment_model.dart';
import 'package:bitacoras_app/features/responsable_practicas/presentation/controllers/company_management_controller.dart';
import 'package:bitacoras_app/features/responsable_practicas/presentation/controllers/student_assignment_controller.dart';
import 'package:bitacoras_app/features/responsable_practicas/presentation/screens/assign_student_form_screen.dart';
import 'package:bitacoras_app/features/responsable_practicas/presentation/screens/company_form_screen.dart';
import 'package:bitacoras_app/features/responsable_practicas/presentation/screens/manage_companies_screen.dart';
import 'package:bitacoras_app/features/responsable_practicas/presentation/screens/student_assignments_screen.dart';
import 'package:bitacoras_app/features/tutores/domain/models/academic_visit_model.dart';
import 'package:bitacoras_app/features/tutores/presentation/screens/register_departure_screen.dart';
import 'package:bitacoras_app/features/tutores/presentation/screens/register_visit_screen.dart';
import 'package:bitacoras_app/features/tutores/presentation/screens/student_tracking_screen.dart';
import 'package:bitacoras_app/features/tutores/presentation/screens/visit_activity_form_screen.dart';

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
    GoRoute(
      path: AppRoutes.assignedStudents,
      builder: (context, state) => const AssignedStudentsScreen(
        currentUser: FakeUserRepository.academicTutor,
        isAcademic: true,
      ),
    ),
    GoRoute(
      path: AppRoutes.companyTutorHome,
      builder: (context, state) => const AssignedStudentsScreen(
        currentUser: FakeUserRepository.companyTutor,
        isAcademic: false,
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterVisit,
      builder: (context, state) => const RegisterVisitScreen(
        currentUser: FakeUserRepository.companyTutor,
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorTracking,
      builder: (context, state) => const StudentTrackingScreen(
        currentUser: FakeUserRepository.academicTutor,
        isAcademic: true,
      ),
    ),
    GoRoute(
      path: AppRoutes.companyTutorTracking,
      builder: (context, state) => const StudentTrackingScreen(
        currentUser: FakeUserRepository.companyTutor,
        isAcademic: false,
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterVisit,
      builder: (context, state) => const RegisterVisitScreen(
        currentUser: FakeUserRepository.academicTutor,
      ),
    ),
    GoRoute(
      path: AppRoutes.visitActivityForm,
      builder: (context, state) {
        final visit = state.extra as AcademicVisitModel;
        return VisitActivityFormScreen(visit: visit);
      },
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterDeparture,
      builder: (context, state) => const RegisterDepartureScreen(
        currentUser: FakeUserRepository.academicTutor,
      ),
    ),
    

    GoRoute(
      path: AppRoutes.responsablePracticasHome,
      builder: (context, state) => const PracticeManagerHome(),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasCompanies,
      builder: (context, state) => const ManageCompaniesScreen(),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasCompanyForm,
      builder: (context, state) {
        // Recibe un mapa o un extra si viene en modo edición
        final extraMap = state.extra as Map<String, dynamic>?;
        final company = extraMap?['company'] as CompanyModel?;
        final controller = extraMap?['controller'] as CompanyManagementController? ??
            CompanyManagementController(
              repository: FakeResponsablePracticasRepository(),
            );

        return CompanyFormScreen(
          company: company,
          controller: controller,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasAssignStudents,
      builder: (context, state) => const StudentAssignmentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasAssignStudentForm,
      builder: (context, state) {
        final extraMap = state.extra as Map<String, dynamic>;
        final assignment = extraMap['assignment'] as StudentAssignmentModel;
        final controller = extraMap['controller'] as StudentAssignmentController;

        return AssignStudentFormScreen(
          assignment: assignment,
          controller: controller,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.coordinatorStudents,
      builder: (context, state) => const CoordinadorEstudiantesScreen(),
    ),
    GoRoute(
      path: AppRoutes.coordinatorCareers,
      builder: (context, state) => const CoordinadorCarrerasScreen(),
    ),
    GoRoute(
      path: AppRoutes.coordinatorTutors,
      builder: (context, state) => const CoordinadorTutoresScreen(),
    ),
  ],
);