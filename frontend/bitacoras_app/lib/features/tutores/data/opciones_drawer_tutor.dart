import 'package:bitacoras_app/features/tutores/tutores.dart';

List<SeccionMenuModel> getOpcionesDrawerTutorAcademico() {
  return [
    const SeccionMenuModel(
      title: 'Tutoría Académica',
      items: [
        ItemMenuModel(
          icon: Icons.people_outline_rounded,
          title: 'Mis Tutoriados',
          route: AppRoutes.assignedStudents,
        ),
        ItemMenuModel(
          icon: Icons.assignment_turned_in_outlined,
          title: 'Registrar Entrada',
          route: AppRoutes.academicTutorRegisterVisit,
        ),
        ItemMenuModel(
          icon: Icons.exit_to_app_outlined,
          title: 'Registrar Salida',
          route: AppRoutes.academicTutorRegisterDeparture,
        ),
        ItemMenuModel(
          icon: Icons.edit_note_outlined,
          title: 'Registrar Actividades',
          route: AppRoutes.academicTutorActivities,
        ),
        ItemMenuModel(
          icon: Icons.description_outlined,
          title: 'Reportes',
          route: AppRoutes.reports,
        ),
      ],
    ),
  ];
}

List<SeccionMenuModel> getOpcionesDrawerTutorEmpresarial() {
  return const [
    SeccionMenuModel(
      title: 'Tutoría Empresarial',
      items: [
        ItemMenuModel(
          icon: Icons.business_center_outlined,
          title: 'Pasantes Asignados',
          route: AppRoutes.assignedStudents,
        ),
        ItemMenuModel(
          icon: Icons.analytics_outlined,
          title: 'Seguimiento',
          route: AppRoutes.companyTutorTracking,
        ),
      ],
    ),
  ];
}