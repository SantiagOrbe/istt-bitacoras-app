import 'package:bitacoras_app/features/admin/admin.dart';

List<SeccionMenuModel> getAdminDrawerSections() {
  return const [
    SeccionMenuModel(
      title: 'Panel de Control',
      items: [
        ItemMenuModel(
          icon: Icons.dashboard_outlined,
          title: 'Inicio Administrador',
          route: AppRoutes.inicioAdmin,
        ),
        ItemMenuModel(
          icon: Icons.people_outline,
          title: 'Gestión de Usuarios',
          route: AppRoutes.gestionUsuarios,
        ),
        ItemMenuModel(
          icon: Icons.school_outlined,
          title: 'Gestión de Carreras',
          route: AppRoutes.gestionCarreras,
        ),
        ItemMenuModel(
          icon: Icons.calendar_month_outlined,
          title: 'Periodos Lectivos',
          route: AppRoutes.gestionPeriodos,
        ),
        ItemMenuModel(
          icon: Icons.business_outlined,
          title: 'Gestión de instituciones',
          route: AppRoutes.gestionEmpresasAdmin,
        ),
        ItemMenuModel(
          icon: Icons.settings_suggest_outlined,
          title: 'Carreras y periodos',
          route: AppRoutes.periodoAcademico,
        ),
      ],
    ),
  ];
}
