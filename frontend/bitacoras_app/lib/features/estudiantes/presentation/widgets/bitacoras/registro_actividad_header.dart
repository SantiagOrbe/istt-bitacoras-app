import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class RegistroActividadHeader extends StatelessWidget {
  const RegistroActividadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Row(
          children: [
            const Icon(Icons.edit_note_rounded, color: AppColores.primary, size: 28),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalles de la actividad',
                    style: AppEstiloTexto.title.copyWith(
                      color: AppColores.primary,
                      fontSize: 20,
                    ),
                  ),
                  AppTamanos.gapV4,
                  Text(
                    'Registra las tareas realizadas en tu bitácora de prácticas.',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
