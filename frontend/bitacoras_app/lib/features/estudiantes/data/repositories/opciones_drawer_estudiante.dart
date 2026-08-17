import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/item_menu_model.dart';

List<SeccionMenuModel> getOpcionesDrawerEstudiante() {
  return const [
    SeccionMenuModel(
      title: 'Principal',
      items: [
        ItemMenuModel(
          icon: Icons.home_outlined,
          title: 'Inicio',
          route: AppRoutes.studentHome,
        ),
        ItemMenuModel(
          icon: Icons.app_registration_outlined,
          title: 'Registrar Asistencia',
          route: AppRoutes.attendance,
        ),
      ],
    ),
    SeccionMenuModel(
      title: 'Mi Proceso',
      items: [
        ItemMenuModel(
          icon: Icons.history_toggle_off_rounded,
          title: 'Historial de Prácticas',
          route: AppRoutes.history,
        ),
        ItemMenuModel(
          icon: Icons.description_outlined,
          title: 'Reportes y Bitácoras',
          route: AppRoutes.reports,
        ),
      ],
    ),
  ];
}
