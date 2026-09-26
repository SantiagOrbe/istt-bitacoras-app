import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/estudiantes/estudiantes.dart'
    as estudiantes;
import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart'
    as rp_feature;
import 'package:bitacoras_app/features/responsable_practicas/domain/models/empresa_model.dart'
    as rp;

// Verifica que el usuario esté autenticado antes de abrir una pantalla.
Widget _requiereAutenticacion(
  BuildContext context,
  Widget Function(UsuarioModel usuarioActual) construirVista,
) {
  final usuarioActual = context.watch<AuthSession>().currentUser;
  if (usuarioActual == null) {
    return LoginScreen(authRepository: context.read<IAuthRepository>());
  }
  return construirVista(usuarioActual);
}

bool _puedeAccederPracticasEstudiante(UsuarioModel usuario) {
  final tieneSemestre = (usuario.semestreId ?? '').trim().isNotEmpty;
  final tieneParalelo = (usuario.paraleloId ?? '').trim().isNotEmpty;
  final tieneEmpresa = (usuario.companyId ?? '').trim().isNotEmpty;
  return usuario.puedeRegistrarPracticas &&
      tieneSemestre &&
      tieneParalelo &&
      tieneEmpresa;
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.inicioSesion,
  routes: [
    ...AuthRoutes.routes,
    GoRoute(
      path: AppRoutes.inicioEstudiante,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) =>
            estudiantes.InicioEstudianteScreen(currentUser: usuarioActual),
      ),
    ),
    GoRoute(
      path: AppRoutes.registrarSalidaAsistencia,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) {
          if (usuarioActual.role == RolUsuarioModel.student &&
              !_puedeAccederPracticasEstudiante(usuarioActual)) {
            return InicioEstudianteScreen(currentUser: usuarioActual);
          }
          return RegistroSalidaScreen(
            currentUser: usuarioActual,
            attendanceRepository: context.read<IAsistenciaRepositorio>(),
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.asistencia,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) {
          if (usuarioActual.role == RolUsuarioModel.student &&
              !_puedeAccederPracticasEstudiante(usuarioActual)) {
            return InicioEstudianteScreen(currentUser: usuarioActual);
          }
          return RegistroAsistenciaScreen(
            currentUser: usuarioActual,
            attendanceRepository: context.read<IAsistenciaRepositorio>(),
            bitacoraRepository: context.read<BitacoraRepositorioImpl>(),
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.registrarActividad,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) {
          if (usuarioActual.role == RolUsuarioModel.student &&
              !_puedeAccederPracticasEstudiante(usuarioActual)) {
            return InicioEstudianteScreen(currentUser: usuarioActual);
          }
          return RegistroActividadScreen(
            currentUser: usuarioActual,
            attendanceRepository: context.read<IAsistenciaRepositorio>(),
            bitacoraRepository: context.read<BitacoraRepositorioImpl>(),
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.historial,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) => HistorialScreen(
          currentUser: usuarioActual,
          attendanceRepository: context.read<IAsistenciaRepositorio>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.reportes,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) {
          if (usuarioActual.role == RolUsuarioModel.academicTutor ||
              usuarioActual.role == RolUsuarioModel.companyTutor) {
            return ReportesTutorScreen(currentUser: usuarioActual);
          }
          return ReportesScreen(
            currentUser: usuarioActual,
            attendanceRepository: context.read<IAsistenciaRepositorio>(),
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.perfilUsuario,
      builder: (context, state) =>
          PerfilScreen(currentUser: context.watch<AuthSession>().currentUser!),
    ),
    GoRoute(
      path: AppRoutes.inicioAdmin,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) => AdminDashboardScreen(
          currentUser: usuarioActual,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.gestionUsuarios,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) => GestionUsuarioScreen(
          currentUser: usuarioActual,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.detalleUsuario,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) => UsuarioDetailScreen(
          user: state.extra as UsuarioModel? ?? usuarioActual,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.gestionCarreras,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => GestionCarreraScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.detalleCarrera,
      builder: (context, state) => _requiereAutenticacion(context, (usuario) {
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
      path: AppRoutes.gestionSemestres,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => GestionCicloScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
          careerId: state.pathParameters['carreraId'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.gestionParalelosAnidados,
      builder: (context, state) => _requiereAutenticacion(
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
      path: AppRoutes.periodoAcademico,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => CarreraPeriodoScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
          initialPeriodId: state.uri.queryParameters['periodoId'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.gestionPeriodos,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => GestionPeriodoScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.gestionCiclos,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => GestionCicloScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.gestionParalelos,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => GestionParaleloScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.gestionEmpresasAdmin,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => GestionEmpresaScreen(
          currentUser: usuario,
          adminRepository: context.read<IAdminRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.inicioDocente,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) => InicioScreen(
          user: usuarioActual,
          actions: const [],
          drawerSections: OpcionesDrawerFactory.getSectionsForRole(
            usuarioActual.role,
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.inicioTutorAcademico,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => InicioTutorAcademicoScreen(
          user: usuario,
          refreshToken: state.uri.queryParameters['refresh'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.inicioTutorEmpresarial,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => InicioTutorEmpresarialScreen(user: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.inicioCoordinador,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => CoordinadorDashboardScreen(
          currentUser: usuario,
          repository: context.read<ICoordinadorRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.inicioResponsablePracticas,
      builder: (context, state) => const InicioResponsablePracticasScreen(),
    ),
    /* GoRoute(
      path: AppRoutes.registrosPracticasAdmin,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => AdminBitacorasScreen(currentUser: usuario),
      ),
    ), */
    GoRoute(
      path: AppRoutes.estudiantesAsignados,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => EstudiantesAsignadosScreen(
          currentUser: usuario,
          isAcademic: usuario.role == RolUsuarioModel.academicTutor,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.registrarVisitaTutor,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => RegistroVisitaScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.seguimientoTutorAcademico,
      builder: (context, state) => _requiereAutenticacion(context, (usuario) {
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
      path: AppRoutes.seguimientoTutorEmpresarial,
      builder: (context, state) => _requiereAutenticacion(context, (usuario) {
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
      path: AppRoutes.registrarSalidaTutor,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => RegistroSalidaVisitaScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.actividadesTutor,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => RegistrarActividadesTutorScreen(currentUser: usuario),
      ),
    ),

    GoRoute(
      path: AppRoutes.inicioResponsable,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (_) => const rp_feature.InicioResponsablePracticasScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.empresasResponsable,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (_) => const GestionEmpresasScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.formularioEmpresaResponsable,
      builder: (context, state) {
        // Recibe un mapa o un extra si viene en modo edición
        final extraMap = state.extra as Map<String, dynamic>?;
        final company = extraMap?['company'] as rp.EmpresaModel?;
        final controller = extraMap?['controller'] as GestionEmpresaController? ??
            GestionEmpresaController(
              repository: context.read<IResponsablePracticasRepository>(),
            );

        return _requiereAutenticacion(
          context,
          (_) => FormularioEmpresaScreen(
            company: company,
            controller: controller,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.detalleEmpresaResponsable,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (_) => DetalleEmpresaResponsableScreen(
          company: state.extra as rp.EmpresaModel,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.asignacionesResponsable,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (_) => const AsignacionEstudiantesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.formularioAsignacionResponsable,
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
      path: AppRoutes.estudiantesCoordinador,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) => CoordinadorEstudiantesScreen(
          currentUser: usuarioActual,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.carrerasCoordinador,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuario) => CoordinadorCarrerasScreen(currentUser: usuario),
      ),
    ),
    GoRoute(
      path: AppRoutes.tutoresCoordinador,
      builder: (context, state) => _requiereAutenticacion(
        context,
        (usuarioActual) => CoordinadorTutoresScreen(
          currentUser: usuarioActual,
        ),
      ),
    ),
  ],
);
