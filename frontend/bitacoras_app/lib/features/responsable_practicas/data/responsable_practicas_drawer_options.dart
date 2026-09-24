import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


List<SeccionMenuModel> getResponsablePracticasDrawerSections() {
  return [
    const SeccionMenuModel(
      title: 'Gestión Administrativa',
      items: [
        ItemMenuModel(
          icon: Icons.person_add_alt_1_outlined,
          title: 'Asignación de Estudiantes',
          route: AppRoutes.responsablePracticasAssignStudents,
        ),
        ItemMenuModel(
          icon: Icons.business_outlined,
          title: 'Gestión de Empresas',
          route: AppRoutes.responsablePracticasCompanies,
        ),
      ],
    ),
  ];
}