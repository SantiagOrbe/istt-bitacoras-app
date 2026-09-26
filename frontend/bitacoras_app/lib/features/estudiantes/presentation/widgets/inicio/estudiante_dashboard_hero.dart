import 'package:bitacoras_app/shared/exports.dart';

class EstudianteDashboardHero extends StatelessWidget {
  final String userName;

  const EstudianteDashboardHero({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColores.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
              ),
              child: const WavingHand(color: AppColores.primary, size: 28),
            ),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Panel del estudiante', style: AppEstiloTexto.heading),
                  AppTamanos.gapV4,
                  Text(
                    'Hola, $userName. Registra y consulta tu jornada de prácticas.',
                    style: AppEstiloTexto.body.copyWith(
                      color: AppColores.textSecondary,
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
