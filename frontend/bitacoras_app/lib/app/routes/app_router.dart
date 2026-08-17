import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_carreras_screen.dart';
import 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_estudiantes_screen.dart';
import 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_tutores_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) =>
          LoginScreen(authRepository: AuthRepositoryImpl()),
    ),
    GoRoute(
      path: AppRoutes.studentHome,
      builder: (context, state) => const InicioEstudianteScreen(),
    ),
    GoRoute(
      path: AppRoutes.registerExitAttendance,
      builder: (context, state) => RegistroSalidaScreen(
        currentUser: FakeUsuarioRepository.student,
        attendanceRepository: FakeAsistenciaRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.attendance,
      builder: (context, state) => RegistroAsistenciaScreen(
        currentUser: FakeUsuarioRepository.student,
        attendanceRepository: FakeAsistenciaRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.registerActivity,
      builder: (context, state) => RegistroActividadScreen(
        currentUser: FakeUsuarioRepository.student,
        attendanceRepository: FakeAsistenciaRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => HistorialScreen(
        currentUser: FakeUsuarioRepository.student,
        attendanceRepository: FakeAsistenciaRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => ReportesScreen(
        currentUser: FakeUsuarioRepository.student,
        attendanceRepository: FakeAsistenciaRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.perfil,
      builder: (context, state) =>
          const PerfilScreen(currentUser: FakeUsuarioRepository.student),
    ),
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (context, state) => const InicioAdminScreen(),
    ),
    GoRoute(
      path: AppRoutes.userManagement,
      builder: (context, state) => GestionUsuarioScreen(
        currentUser: FakeUsuarioRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.userDetail,
      builder: (context, state) {
        final user = state.extra as UsuarioModel?;

        return UsuarioDetailScreen(
          user: user ?? FakeUsuarioRepository.admin,
          adminRepository: FakeAdminRepository(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.careerManagement,
      builder: (context, state) => GestionCarreraScreen(
        currentUser: FakeUsuarioRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.careerDetail,
      builder: (context, state) {
        final career = state.extra as CarreraModel?;

        return CarreraDetailScreen(
          currentUser: FakeUsuarioRepository.admin,
          career:
              career ??
              const CarreraModel(
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
      builder: (context, state) => CarreraPeriodoScreen(
        currentUser: FakeUsuarioRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.periodManagement,
      builder: (context, state) => GestionPeriodoScreen(
        currentUser: FakeUsuarioRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.cycleManagement,
      builder: (context, state) => GestionCicloScreen(
        currentUser: FakeUsuarioRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.parallelManagement,
      builder: (context, state) => GestionParaleloScreen(
        currentUser: FakeUsuarioRepository.admin,
        adminRepository: FakeAdminRepository(),
      ),
    ),
    GoRoute(
      path: AppRoutes.teacherHome,
      builder: (context, state) => const InicioDocenteScreen(),
    ),
    GoRoute(
      path: AppRoutes.academicTutorHome,
      builder: (context, state) => const InicioTutorAcademicoScreen(),
    ),
    GoRoute(
      path: AppRoutes.companyTutorHome,
      builder: (context, state) => const InicioTutorEmpresarialScreen(),
    ),
    GoRoute(
      path: AppRoutes.coordinatorHome,
      builder: (context, state) => const InicioCoordinadorScreen(),
    ),
    GoRoute(
      path: AppRoutes.practiceManagerHome,
      builder: (context, state) => const InicioResponsablePracticasScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminPracticeLogs,
      builder: (context, state) =>
          const AdminBitacorasScreen(currentUser: FakeUsuarioRepository.admin),
    ),
    GoRoute(
      path: AppRoutes.assignedStudents,
      builder: (context, state) => const EstudiantesAsignadosScreen(
        currentUser: FakeUsuarioRepository.academicTutor,
        isAcademic: true,
      ),
    ),
    GoRoute(
      path: AppRoutes.companyTutorHome,
      builder: (context, state) => const EstudiantesAsignadosScreen(
        currentUser: FakeUsuarioRepository.companyTutor,
        isAcademic: false,
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterVisit,
      builder: (context, state) => const RegistroVisitaScreen(
        currentUser: FakeUsuarioRepository.companyTutor,
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorTracking,
      builder: (context, state) => const SeguimientoEstudiantesScreen(
        currentUser: FakeUsuarioRepository.academicTutor,
        isAcademic: true,
      ),
    ),
    GoRoute(
      path: AppRoutes.companyTutorTracking,
      builder: (context, state) => const SeguimientoEstudiantesScreen(
        currentUser: FakeUsuarioRepository.companyTutor,
        isAcademic: false,
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterVisit,
      builder: (context, state) => const RegistroVisitaScreen(
        currentUser: FakeUsuarioRepository.academicTutor,
      ),
    ),
    GoRoute(
      path: AppRoutes.visitActivityForm,
      builder: (context, state) {
        final visit = state.extra as VisitaAcademicaModel;
        return FormularioActividadVisitaScreen(visit: visit);
      },
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterDeparture,
      builder: (context, state) => const RegistroSalidaVisitaScreen(
        currentUser: FakeUsuarioRepository.academicTutor,
      ),
    ),

    GoRoute(
      path: AppRoutes.responsablePracticasHome,
      builder: (context, state) => const InicioResponsablePracticasScreen(),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasCompanies,
      builder: (context, state) => const GestionEmpresasScreen(),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasCompanyForm,
      builder: (context, state) {
        // Recibe un mapa o un extra si viene en modo edición
        final extraMap = state.extra as Map<String, dynamic>?;
        final company = extraMap?['company'] as EmpresaModel?;
        final controller =
            extraMap?['controller'] as GestionEmpresaController? ??
            GestionEmpresaController(
              repository: FakeResponsablePracticasRepository(),
            );

        return FormularioEmpresaScreen(company: company, controller: controller);
      },
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasAssignStudents,
      builder: (context, state) => const AsignacionEstudiantesScreen(),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasAssignStudentForm,
      builder: (context, state) {
        final extraMap = state.extra as Map<String, dynamic>;
        final assignment = extraMap['assignment'] as AsignacionEstudianteModel;
        final controller =
            extraMap['controller'] as AsignacionEstudianteController;

        return FormularioAsignacionEstudianteScreen(
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
