import 'package:bitacoras_app/features/coordinador/coordinador.dart';

List<SeccionMenuModel> getCoordinatorDrawerSections() {
  return [
    const SeccionMenuModel(
      title: 'MENÚ PRINCIPAL',
      items: [
        ItemMenuModel(
          title: 'Estudiantes',
          icon: Icons.school_rounded,
          route: AppRoutes.estudiantesCoordinador,
        ),
        ItemMenuModel(
          title: 'Tutores',
          icon: Icons.badge_rounded,
          route: AppRoutes.tutoresCoordinador,
        ),
        ItemMenuModel(
          title: 'Carreras',
          icon: Icons.account_tree_outlined,
          route: AppRoutes.carrerasCoordinador,
        ),
      ],
    ),
  ];
}
