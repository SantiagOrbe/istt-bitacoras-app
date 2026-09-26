import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

List<SeccionMenuModel> getOpcionesDrawerEstudiante({
  bool canEnter = true,
  bool canActivities = false,
  bool canExit = false,
  bool canAccessPracticas = true,
}) {
  return [
    SeccionMenuModel(
      title: 'Principal',
      items: [
        ItemMenuModel(
          icon: Icons.home_outlined,
          title: 'Inicio',
          route: AppRoutes.inicioEstudiante,
        ),
        ItemMenuModel(
          icon: Icons.app_registration_outlined,
          title: 'Registrar Asistencia',
          route: AppRoutes.asistencia,
          enabled: canAccessPracticas && canEnter,
        ),
        ItemMenuModel(
          icon: Icons.edit_note_outlined,
          title: 'Registrar Actividades',
          route: AppRoutes.registrarActividad,
          enabled: canAccessPracticas && canActivities,
        ),
        ItemMenuModel(
          icon: Icons.logout_outlined,
          title: 'Registrar Salida',
          route: AppRoutes.registrarSalidaAsistencia,
          enabled: canAccessPracticas && canExit,
        ),
      ],
    ),
    SeccionMenuModel(
      title: 'Mi Proceso',
      items: [
        ItemMenuModel(
          icon: Icons.history_toggle_off_rounded,
          title: 'Avance de Prácticas',
          route: AppRoutes.historial,
          enabled: canAccessPracticas,
        ),
        ItemMenuModel(
          icon: Icons.description_outlined,
          title: 'Reportes y Bitácoras',
          route: AppRoutes.reportes,
          enabled: canAccessPracticas,
        ),
      ],
    ),
  ];
}
