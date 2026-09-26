class AppRoutes {
  AppRoutes._();

  // Rutas base
  static const pantallaCarga = '/';
  static const inicioSesion = '/login';
  static const registro = '/register';

  // Pantallas principales por rol
  static const inicioEstudiante = '/student';
  static const inicioTutor = '/tutor';
  static const inicioAdmin = '/admin';

  // Módulos generales
  static const asistencia = '/attendance';
  static const registrarActividad = '/attendance/activity';
  static const historial = '/history';
  static const reportes = '/reports';
  static const perfilUsuario = '/perfil';
  static const gestionUsuarios = '/admin/user-management';
  static const detalleUsuario = '/admin/user-detail';
  static const gestionCarreras = '/admin/careers';
  static const detalleCarrera = '/admin/careers/detail';
  static const periodoAcademico = '/admin/career-period';
  static const gestionPeriodos = '/admin/periods';
  static const gestionCiclos = '/admin/cycles';
  static const gestionParalelos = '/admin/parallels';
  static const gestionSemestres = '/admin/careers/:carreraId/semestres';
  static const gestionParalelosAnidados =
      '/admin/careers/:carreraId/semestres/:semestreId/paralelos';
  static const gestionEmpresasAdmin = '/admin/companies';
  static const registrarSalidaAsistencia = '/attendance/exit-attendance';

  // Homes por rol
  static const inicioDocente = '/teacher';
  static const inicioTutorAcademico = '/academic-tutor';
  static const inicioTutorEmpresarial = '/company-tutor';
  static const inicioCoordinador = '/coordinator';
  static const inicioResponsablePracticas = '/practice-manager';

  // Administración
  static const registrosPracticasAdmin = '/admin/practice-logs';

  // Tutores
  static const estudiantesAsignados = '/tutor/assigned-students';
  static const registrarVisitaTutor = '/tutor/register-visit';
  static const seguimientoTutorEmpresarial = '/company-tutor/tracking';
  static const seguimientoTutorAcademico = '/academic-tutor/tracking';
  static const registrarSalidaTutor = '/tutor/register-departure';
  static const actividadesTutor = '/tutor/activities';

  // Responsable de prácticas
  static const inicioResponsable = '/responsable-practicas';
  static const empresasResponsable = '/responsable-practicas/empresas';
  static const formularioEmpresaResponsable =
      '/responsable-practicas/empresas/formulario';
  static const detalleEmpresaResponsable =
      '/responsable-practicas/empresas/detalle';
  static const asignacionesResponsable =
      '/responsable-practicas/asignaciones';
  static const formularioAsignacionResponsable =
      '/responsable-practicas/asignaciones/formulario';

  // Coordinador
  static const estudiantesCoordinador = '/coordinator-students';
  static const carrerasCoordinador = '/coordinator-careers';
  static const tutoresCoordinador = '/coordinator-tutors';
}
