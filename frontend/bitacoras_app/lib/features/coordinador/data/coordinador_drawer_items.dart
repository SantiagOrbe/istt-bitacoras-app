import '../../../../app/apps.dart';

List<SeccionMenuModel> getCoordinatorDrawerSections() {
  return [
    const SeccionMenuModel(
      title: 'MENÚ PRINCIPAL',
      items: [
        ItemMenuModel(
          title: 'Estudiantes',
          icon: Icons.school_rounded,
          route: AppRoutes.coordinatorStudents,
        ),
        ItemMenuModel(
          title: 'Tutores',
          icon: Icons.badge_rounded,
          route: AppRoutes.coordinatorTutors,
        ),
      ],
    ),
    
  ];
}