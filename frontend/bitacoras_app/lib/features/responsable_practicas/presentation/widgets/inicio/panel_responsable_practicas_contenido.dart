import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class PanelResponsablePracticasContenido extends StatelessWidget {
  final UsuarioModel currentUser;

  const PanelResponsablePracticasContenido({
    super.key,
    required this.currentUser,
  });

  static const List<ModuloResponsablePracticas> _modulos = [
    ModuloResponsablePracticas(
      title: 'Gestión de Empresas',
      subtitle: 'Catálogo de instituciones y convenios',
      icon: Icons.business_outlined,
      route: AppRoutes.empresasResponsable,
      accentColor: AppColores.secondary,
    ),
    ModuloResponsablePracticas(
      title: 'Asignación de Estudiantes',
      subtitle: 'Vincular estudiantes y tutores',
      icon: Icons.person_add_alt_1_outlined,
      route: AppRoutes.asignacionesResponsable,
      accentColor: AppColores.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTamanos.md),
          children: [
            PanelResponsablePracticasHero(userName: currentUser.name),
            AppTamanos.gapV20,
            Text('Accesos de gestión', style: AppEstiloTexto.title),
            AppTamanos.gapV12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _modulos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: AppTamanos.sm,
                mainAxisSpacing: AppTamanos.sm,
                childAspectRatio: isWide ? 1.65 : 1.12,
              ),
              itemBuilder: (context, index) {
                final module = _modulos[index];
                return TarjetaModuloResponsablePracticas(
                  module: module,
                  onTap: () => context.push(module.route),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
