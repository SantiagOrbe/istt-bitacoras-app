import 'package:flutter/material.dart';
import '../../../../app/apps.dart';

List<DrawerSectionModel> getCoordinatorDrawerSections() {
  return [
    const DrawerSectionModel(
      title: 'MENÚ PRINCIPAL',
      items: [
        DrawerItemModel(
          title: 'Carreras',
          icon: Icons.account_tree_rounded,
          route: AppRoutes.coordinatorCareers,
        ),
        DrawerItemModel(
          title: 'Estudiantes',
          icon: Icons.school_rounded,
          route: AppRoutes.coordinatorStudents,
        ),
        DrawerItemModel(
          title: 'Tutores',
          icon: Icons.badge_rounded,
          route: AppRoutes.coordinatorTutors,
        ),
      ],
    ),
    
  ];
}