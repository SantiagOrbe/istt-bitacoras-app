import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class PanelResponsablePracticasHero extends StatefulWidget {
  final String userName;

  const PanelResponsablePracticasHero({
    super.key,
    required this.userName,
  });

  @override
  State<PanelResponsablePracticasHero> createState() =>
      _PanelResponsablePracticasHeroState();
}

class _PanelResponsablePracticasHeroState
    extends State<PanelResponsablePracticasHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

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
                  Text(
                    'Panel del responsable de prácticas',
                    style: AppEstiloTexto.heading,
                  ),
                  AppTamanos.gapV4,
                  Text(
                    'Hola, ${widget.userName}. Gestiona empresas y asignaciones de prácticas.',
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
