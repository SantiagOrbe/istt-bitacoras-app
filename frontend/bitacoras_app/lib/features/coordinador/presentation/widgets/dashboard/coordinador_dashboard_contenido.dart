import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorDashboardContenido extends StatelessWidget {
  final UsuarioModel currentUser;
  final int cantidadCarreras;
  final int cantidadEstudiantes;
  final int cantidadTutores;

  const CoordinadorDashboardContenido({
    super.key,
    required this.currentUser,
    required this.cantidadCarreras,
    required this.cantidadEstudiantes,
    required this.cantidadTutores,
  });

  List<CoordinadorDashboardModulo> get modulos => [
    CoordinadorDashboardModulo(
      'Estudiantes',
      'Consulta de estudiantes',
      Icons.groups_outlined,
      AppRoutes.estudiantesCoordinador,
      AppColores.secondary,
    ),
    CoordinadorDashboardModulo(
      'Tutores',
      'Consulta de tutores',
      Icons.badge_outlined,
      AppRoutes.tutoresCoordinador,
      AppColores.info,
    ),
    CoordinadorDashboardModulo(
      'Carreras',
      'Consulta del catálogo académico',
      Icons.account_tree_outlined,
      AppRoutes.carrerasCoordinador,
      AppColores.primary,
    ),
    CoordinadorDashboardModulo(
      'Mi perfil',
      'Información de la cuenta',
      Icons.person_outline,
      AppRoutes.perfilUsuario,
      AppColores.success,
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
            CoordinadorDashboardHero(userName: currentUser.name),
            AppTamanos.gapV20,
            Text('Accesos de gestión', style: AppEstiloTexto.title),
            AppTamanos.gapV12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modulos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: AppTamanos.sm,
                mainAxisSpacing: AppTamanos.sm,
                childAspectRatio: isWide ? 1.65 : 1.12,
              ),
              itemBuilder: (context, index) {
                final module = modulos[index];
                return CoordinadorDashboardModuloCard(
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
