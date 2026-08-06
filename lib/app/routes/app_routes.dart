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
  static const profile = '/profile';
  static const String userManagement = '/admin/user-management';
  static const String careerPeriod = '/admin/career-period';
  static const String registerExitAttendance = '/attendance/exit-attendance';

  // Homes
  static const String teacherHome = '/teacher';
  static const String academicTutorHome = '/academic-tutor';
  static const String companyTutorHome = '/company-tutor';
  static const String coordinatorHome = '/coordinator';
  static const String practiceManagerHome = '/practice-manager';

}