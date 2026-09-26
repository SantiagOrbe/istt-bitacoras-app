import 'package:bitacoras_app/features/tutores/tutores.dart';

class EncabezadoSeguimientoEstudiantes extends StatelessWidget {
  final UsuarioModel currentUser;

  const EncabezadoSeguimientoEstudiantes({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seguimiento de Prácticas', style: AppEstiloTexto.heading),
            AppTamanos.gapV4,
            Text(
              'Tutor: ${currentUser.name}',
              style: AppEstiloTexto.body.copyWith(color: AppColores.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
