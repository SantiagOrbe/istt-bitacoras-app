
import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/drawer_item_model.dart';


List<DrawerSectionModel> getStudentDrawerSections() {
  return const [
    DrawerSectionModel(
      title: 'Principal',
      items: [
        DrawerItemModel(
          icon: Icons.home_outlined,
          title: 'Inicio',
          route: AppRoutes.studentHome,
        ),
        DrawerItemModel(
          icon: Icons.app_registration_outlined,
          title: 'Registrar Asistencia',
          route: AppRoutes.attendance,
        ),
      ],
    ),
    DrawerSectionModel(
      title: 'Mi Proceso',
      items: [
        DrawerItemModel(
          icon: Icons.history_toggle_off_rounded,
          title: 'Historial de Prácticas',
          route: AppRoutes.history,
        ),
        DrawerItemModel(
          icon: Icons.description_outlined,
          title: 'Reportes y Bitácoras',
          route: AppRoutes.reports,
        ),
      ],
    ),
  ];
}