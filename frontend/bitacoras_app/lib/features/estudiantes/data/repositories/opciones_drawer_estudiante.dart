import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

List<SeccionMenuModel> getOpcionesDrawerEstudiante({
  bool canEnter = true,
  bool canActivities = false,
  bool canExit = false,
}) {
  return [
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
          enabled: canEnter,
        ),
        ItemMenuModel(
          icon: Icons.edit_note_outlined,
          title: 'Registrar Actividades',
          route: AppRoutes.registerActivity,
          enabled: canActivities,
        ),
        ItemMenuModel(
          icon: Icons.logout_outlined,
          title: 'Registrar Salida',
          route: AppRoutes.registerExitAttendance,
          enabled: canExit,
        ),
      ],
    ),
    SeccionMenuModel(
      title: 'Mi Proceso',
      items: [
        ItemMenuModel(
          icon: Icons.history_toggle_off_rounded,
          title: 'Avance de Prácticas',
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
