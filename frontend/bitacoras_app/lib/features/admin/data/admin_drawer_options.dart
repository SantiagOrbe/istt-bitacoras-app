import 'package:bitacoras_app/app/apps.dart';

List<SeccionMenuModel> getAdminDrawerSections() {
  return const [
    SeccionMenuModel(
      title: 'Panel de Control',
      items: [
        ItemMenuModel(
          icon: Icons.dashboard_outlined,
          title: 'Inicio Administrador',
          route: AppRoutes.adminHome,
        ),
        ItemMenuModel(
          icon: Icons.people_outline,
          title: 'Gestión de Usuarios',
          route: AppRoutes.userManagement,
        ),
        ItemMenuModel(
          icon: Icons.school_outlined,
          title: 'Gestión de Carreras',
          route: AppRoutes.careerManagement,
        ),
        ItemMenuModel(
          icon: Icons.calendar_month_outlined,
          title: 'Periodos Lectivos',
          route: AppRoutes.periodManagement,
        ),
        ItemMenuModel(
          icon: Icons.layers_outlined,
          title: 'Ciclos / Cursos',
          route: AppRoutes.cycleManagement,
        ),
        ItemMenuModel(
          icon: Icons.grid_view_outlined,
          title: 'Paralelos y Jornadas',
          route: AppRoutes.parallelManagement,
        ),
        ItemMenuModel(
          icon: Icons.settings_suggest_outlined,
          title: 'Config. Carrera - Periodo',
          route: AppRoutes.careerPeriod,
        ),
      ],
    ),
    SeccionMenuModel(
      title: 'Auditoría y Prácticas',
      items: [
        ItemMenuModel(
          icon: Icons.assignment_turned_in_outlined,
          title: 'Registro de Bitácoras',
          route: AppRoutes.adminPracticeLogs,
        ),
      ],
    ),
  ];
}
