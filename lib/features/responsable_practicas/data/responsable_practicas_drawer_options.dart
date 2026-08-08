// lib/features/responsable_practicas/data/responsable_practicas_drawer_options.dart

import 'package:flutter/material.dart';
import '../../../../app/apps.dart';

List<DrawerSectionModel> getResponsablePracticasDrawerSections() {
  return [
    const DrawerSectionModel(
      title: 'Gestión Administrativa',
      items: [
        DrawerItemModel(
          icon: Icons.person_add_alt_1_outlined,
          title: 'Asignación de Estudiantes',
          route: AppRoutes.responsablePracticasAssignStudents,
        ),
        DrawerItemModel(
          icon: Icons.business_outlined,
          title: 'Gestión de Empresas',
          route: AppRoutes.responsablePracticasCompanies,
        ),
      ],
    ),
  ];
}