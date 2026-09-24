import 'package:bitacoras_app/features/admin/admin.dart';

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
          icon: Icons.business_outlined,
          title: 'Gestión de instituciones',
          route: AppRoutes.companyManagement,
        ),
        ItemMenuModel(
          icon: Icons.settings_suggest_outlined,
          title: 'Carreras y periodos',
          route: AppRoutes.careerPeriod,
        ),
      ],
    ),
  ];
}
