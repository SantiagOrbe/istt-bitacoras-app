import 'package:bitacoras_app/features/tutores/tutores.dart';

List<SeccionMenuModel> getOpcionesDrawerTutorAcademico({
  EstadoVisitaTutorModel? visita,
}) {
  final estado = visita ?? const EstadoVisitaTutorModel();

  return [
    SeccionMenuModel(
      title: 'Tutoría Académica',
      items: [
        const ItemMenuModel(
          icon: Icons.people_outline_rounded,
          title: 'Mis Tutoriados',
          route: AppRoutes.estudiantesAsignados,
          enabled: true,
        ),
        ItemMenuModel(
          icon: Icons.assignment_turned_in_outlined,
          title: 'Registrar Entrada',
          route: AppRoutes.registrarVisitaTutor,
          enabled: estado.puedeRegistrarEntrada,
        ),
        ItemMenuModel(
          icon: Icons.exit_to_app_outlined,
          title: 'Registrar Salida',
          route: AppRoutes.registrarSalidaTutor,
          enabled: estado.puedeRegistrarSalida,
        ),
        ItemMenuModel(
          icon: Icons.edit_note_outlined,
          title: 'Registrar Actividades',
          route: AppRoutes.actividadesTutor,
          enabled: estado.puedeRegistrarActividades,
        ),
        const ItemMenuModel(
          icon: Icons.description_outlined,
          title: 'Reportes',
          route: AppRoutes.reportes,
          enabled: true,
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
          route: AppRoutes.estudiantesAsignados,
        ),
        ItemMenuModel(
          icon: Icons.analytics_outlined,
          title: 'Seguimiento',
          route: AppRoutes.seguimientoTutorEmpresarial,
        ),
      ],
    ),
  ];
}