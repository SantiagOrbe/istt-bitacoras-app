class AppRoutes {
  // Constructor privado para evitar instanciación
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';

  // Pantallas Principales por Rol
  static const studentHome = '/student';
  static const tutorHome = '/tutor';
  static const adminHome = '/admin';

  // Módulos
  static const attendance = '/attendance';
  static const registerActivity = '/attendance/activity';
  static const history = '/history';
  static const reports = '/reports';
  static const perfil = '/perfil';
  static const String userManagement = '/admin/user-management';
  static const String userDetail = '/admin/user-detail';
  static const String careerManagement = '/admin/careers';
  static const String careerDetail = '/admin/careers/detail';
  static const String careerPeriod = '/admin/career-period';
  static const String periodManagement = '/admin/periods';
  static const String cycleManagement = '/admin/cycles';
  static const String parallelManagement = '/admin/parallels';
  static const String registerExitAttendance = '/attendance/exit-attendance';

  // Homes
  static const String teacherHome = '/teacher';
  static const String academicTutorHome = '/academic-tutor';
  static const String companyTutorHome = '/company-tutor';
  static const String coordinatorHome = '/coordinator';
  static const String practiceManagerHome = '/practice-manager';

  //Admin
  static const String adminPracticeLogs = '/admin/practice-logs';

  // Tutores
  static const String assignedStudents = '/tutor/assigned-students';
  static const String academicTutorRegisterVisit = '/tutor/register-visit';
  static const String companyTutorTracking = '/company-tutor/tracking';
  static const String visitActivityForm = '/tutor/visit-activity-form';
  static const String academicTutorTracking = '/academic-tutor/tracking';
  static const String academicTutorRegisterDeparture =
      '/tutor/register-departure';

  // Responsable de Prácticas
  static const String responsablePracticasHome = '/responsable-practicas';
  static const String responsablePracticasCompanies =
      '/responsable-practicas/empresas';
  static const String responsablePracticasCompanyForm =
      '/responsable-practicas/empresas/formulario';
  static const String responsablePracticasAssignStudents =
      '/responsable-practicas/asignaciones';
  static const String responsablePracticasAssignStudentForm =
      '/responsable-practicas/asignaciones/formulario';

  //coordinador
  static const String coordinatorStudents = '/coordinator-students';
  static const String coordinatorCareers = '/coordinator-careers';
  static const String coordinatorTutors = '/coordinator-tutors';
}
