import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/estudiantes/estudiantes.dart'
    as estudiantes;
import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart'
    as rp_feature;
import 'package:bitacoras_app/features/responsable_practicas/domain/models/empresa_model.dart'
    as rp;

Widget _requiereSesion(
  BuildContext context,
  Widget Function(UsuarioModel usuario) construir,
) {
  final usuario = context.watch<AuthSession>().currentUser;
  if (usuario == null) {
    return LoginScreen(authRepository: context.read<IAuthRepository>());
  }
  return construir(usuario);
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    ...AuthRoutes.routes,
    GoRoute(
      path: AppRoutes.studentHome,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => estudiantes.InicioEstudianteScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.registerExitAttendance,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => RegistroSalidaScreen(
          currentUser: usuario,
          attendanceRepository: context.read<IAsistenciaRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.attendance,
      builder: (context, state) => RegistroAsistenciaScreen(
        currentUser: context.watch<AuthSession>().currentUser!,
        attendanceRepository: context.read<IAsistenciaRepository>(),
        bitacoraRepository: context.read<BitacoraRepositoryImpl>(),
      ),
    ),
    GoRoute(
      path: AppRoutes.registerActivity,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => RegistroActividadScreen(
          currentUser: usuario,
          attendanceRepository: context.read<IAsistenciaRepository>(),
          bitacoraRepository: context.read<BitacoraRepositoryImpl>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => HistorialScreen(
          currentUser: usuario,
          attendanceRepository: context.read<IAsistenciaRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => _requiereSesion(
        context,
        (user) {
        if (user.role == RolUsuarioModel.academicTutor ||
            user.role == RolUsuarioModel.companyTutor) {
          return ReportesTutorScreen(currentUser: user);
        }
        return ReportesScreen(
          currentUser: user,
          attendanceRepository: context.read<IAsistenciaRepository>(),
        );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.perfil,
      builder: (context, state) =>
          PerfilScreen(currentUser: context.watch<AuthSession>().currentUser!),
    ),
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => AdminDashboardScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.userManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionUsuarioScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.userDetail,
      builder: (context, state) => _requiereSesion(
        context,
        (usuarioActual) => UsuarioDetailScreen(
          user: state.extra as UsuarioModel? ?? usuarioActual,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.careerManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionCarreraScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.careerDetail,
      builder: (context, state) => _requiereSesion(context, (usuario) {
        final career = state.extra as CarreraModel?;
        return CarreraDetailScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
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
      }),
    ),
    GoRoute(
      path: AppRoutes.semesterManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionCicloScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
          careerId: state.pathParameters['carreraId'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.nestedParallelManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionParaleloScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
          careerId: state.pathParameters['carreraId'],
          semesterId: state.pathParameters['semestreId'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.careerPeriod,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => CarreraPeriodoScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.periodManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionPeriodoScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.cycleManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionCicloScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.parallelManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionParaleloScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.companyManagement,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => GestionEmpresaScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.teacherHome,
      builder: (context, state) => const InicioDocenteScreen(),
    ),
    GoRoute(
      path: AppRoutes.academicTutorHome,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => InicioTutorAcademicoScreen(
          user: usuario,
          refreshToken: state.uri.queryParameters['refresh'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.companyTutorHome,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => InicioTutorEmpresarialScreen(user: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.coordinatorHome,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => CoordinadorDashboardScreen(
          currentUser: usuario,
          repository: context.read<ICoordinadorRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.practiceManagerHome,
      builder: (context, state) => const InicioResponsablePracticasScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminPracticeLogs,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => AdminBitacorasScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.assignedStudents,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => EstudiantesAsignadosScreen(
          currentUser: usuario,
          isAcademic: usuario.role == RolUsuarioModel.academicTutor,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterVisit,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => RegistroVisitaScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorTracking,
      builder: (context, state) => _requiereSesion(context, (usuario) {
        final assignedStudent = state.extra as EstudianteAsignadoModel?;
        if (assignedStudent != null) {
          return DetalleSeguimientoEstudianteScreen(
            assignedStudent: assignedStudent,
            recordsOnly: true,
          );
        }
        return SeguimientoEstudiantesScreen(
          currentUser: usuario,
          isAcademic: true,
        );
      }),
    ),
    GoRoute(
      path: AppRoutes.companyTutorTracking,
      builder: (context, state) => _requiereSesion(context, (usuario) {
        final assignedStudent = state.extra as EstudianteAsignadoModel?;
        if (assignedStudent != null) {
          return DetalleSeguimientoEstudianteScreen(
            assignedStudent: assignedStudent,
            isAcademic: false,
            recordsOnly: true,
          );
        }
        return SeguimientoEstudiantesScreen(
          currentUser: usuario,
          isAcademic: false,
        );
      }),
    ),
    GoRoute(
      path: AppRoutes.academicTutorRegisterDeparture,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => RegistroSalidaVisitaScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.academicTutorActivities,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => RegistrarActividadesTutorScreen(currentUser: usuario),
      ),
    ),

    GoRoute(
      path: AppRoutes.responsablePracticasHome,
      builder: (context, state) => _requiereSesion(
        context,
        (_) => const rp_feature.InicioResponsablePracticasScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasCompanies,
      builder: (context, state) => _requiereSesion(
        context,
        (_) => const GestionEmpresasScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasCompanyForm,
      builder: (context, state) {
        // Recibe un mapa o un extra si viene en modo edición
        final extraMap = state.extra as Map<String, dynamic>?;
        final company = extraMap?['company'] as rp.EmpresaModel?;
        final controller = extraMap?['controller'] as GestionEmpresaController? ??
            GestionEmpresaController(
              repository: context.read<IResponsablePracticasRepository>(),
            );

        return _requiereSesion(
          context,
          (_) => FormularioEmpresaScreen(
            company: company,
            controller: controller,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasCompanyDetail,
      builder: (context, state) => _requiereSesion(
        context,
        (_) => DetalleEmpresaResponsableScreen(
          company: state.extra as rp.EmpresaModel,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.responsablePracticasAssignStudents,
      builder: (context, state) => _requiereSesion(
        context,
        (_) => const AsignacionEstudiantesScreen(),
      ),
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
      builder: (context, state) => CoordinadorEstudiantesScreen(
        currentUser:
            context.watch<AuthSession>().currentUser ??
            FakeUsuarioRepository.coordinator,
      ),
    ),
    GoRoute(
      path: AppRoutes.coordinatorCareers,
      builder: (context, state) => _requiereSesion(
        context,
        (usuario) => CoordinadorCarrerasScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.coordinatorTutors,
      builder: (context, state) => CoordinadorTutoresScreen(
        currentUser:
            context.watch<AuthSession>().currentUser ??
            FakeUsuarioRepository.coordinator,
      ),
    ),
  ],
);
