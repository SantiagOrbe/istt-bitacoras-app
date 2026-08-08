import '../../../../app/apps.dart';

List<DrawerSectionModel> getAcademicTutorDrawerSections() {
  return [
    const DrawerSectionModel(
      title: 'Tutoría Académica',
      items: [
        DrawerItemModel(
          icon: Icons.people_outline_rounded,
          title: 'Mis Tutoriados',
          route: AppRoutes.assignedStudents,
        ),
        DrawerItemModel(
          icon: Icons.assignment_turned_in_outlined,
          title: 'Registrar Entrada',
          route: AppRoutes.academicTutorRegisterVisit,
        ),
        DrawerItemModel(
          icon: Icons.exit_to_app_outlined,
          title: 'Registrar Salida',
          route: AppRoutes.academicTutorRegisterDeparture,
        ),
        DrawerItemModel(
          icon: Icons.analytics_outlined,
          title: 'Seguimiento de Prácticas',
          route: AppRoutes.academicTutorTracking,
        ),
      ],
    ),
  ];
}

List<DrawerSectionModel> getCompanyTutorDrawerSections() {
  return const [
    DrawerSectionModel(
      title: 'Tutoría Empresarial',
      items: [
        DrawerItemModel(
          icon: Icons.business_center_outlined,
          title: 'Pasantes Asignados',
          route: AppRoutes.assignedStudents,
        ),
        DrawerItemModel(
          icon: Icons.analytics_outlined,
          title: 'Seguimiento de Prácticas',
          route: AppRoutes.companyTutorTracking,
        ),
      ],
    ),
  ];
}