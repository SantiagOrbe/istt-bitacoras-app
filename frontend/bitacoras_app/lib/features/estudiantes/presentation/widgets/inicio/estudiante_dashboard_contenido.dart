import 'package:bitacoras_app/features/estudiantes/presentation/widgets/inicio/estudiante_dashboard_hero.dart';
import 'package:bitacoras_app/features/estudiantes/presentation/widgets/inicio/estudiante_dashboard_modulo.dart';
import 'package:bitacoras_app/features/estudiantes/presentation/widgets/inicio/estudiante_dashboard_modulo_card.dart';
import 'package:bitacoras_app/shared/exports.dart';
import 'package:go_router/go_router.dart';

class EstudianteDashboardContenido extends StatelessWidget {
  final UsuarioModel currentUser;
  final bool canEnter;
  final bool canActivity;
  final bool canExit;
  final bool canAccessPracticas;

  const EstudianteDashboardContenido({
    super.key,
    required this.currentUser,
    required this.canEnter,
    required this.canActivity,
    required this.canExit,
    this.canAccessPracticas = true,
  });

  List<EstudianteDashboardModulo> get modulos => [
    EstudianteDashboardModulo(
      'Registrar entrada',
      'Marcar inicio de jornada',
      Icons.login_outlined,
      AppRoutes.asistencia,
      AppColores.secondary,
      canAccessPracticas && canEnter,
    ),
    EstudianteDashboardModulo(
      'Registrar actividades',
      'Describir las actividades de hoy',
      Icons.edit_note_outlined,
      AppRoutes.registrarActividad,
      AppColores.info,
      canAccessPracticas && canActivity,
    ),
    EstudianteDashboardModulo(
      'Registrar salida',
      'Marcar fin de jornada',
      Icons.logout_outlined,
      AppRoutes.registrarSalidaAsistencia,
      AppColores.warning,
      canAccessPracticas && canExit,
    ),
    EstudianteDashboardModulo(
      'Reportes',
      'Descargar informe de prácticas',
      Icons.description_outlined,
      AppRoutes.reportes,
      AppColores.success,
      canAccessPracticas,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTamanos.md),
          children: [
            EstudianteDashboardHero(userName: currentUser.name),
            AppTamanos.gapV20,
            Text('Accesos de práctica', style: AppEstiloTexto.title),
            AppTamanos.gapV12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modulos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTamanos.sm,
                mainAxisSpacing: AppTamanos.sm,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final module = modulos[index];
                return EstudianteDashboardModuloCard(
                  module: module,
                  onTap: module.enabled ? () => context.push(module.route) : null,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
