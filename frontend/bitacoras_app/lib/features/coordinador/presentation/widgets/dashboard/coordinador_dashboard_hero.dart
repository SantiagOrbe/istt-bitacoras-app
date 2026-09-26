import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorDashboardHero extends StatefulWidget {
  final String userName;

  const CoordinadorDashboardHero({
    super.key,
    required this.userName,
  });

  @override
  State<CoordinadorDashboardHero> createState() =>
      _CoordinadorDashboardHeroState();
}

class _CoordinadorDashboardHeroState extends State<CoordinadorDashboardHero>
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
              child: const WavingHand(
                color: AppColores.primary,
                size: 28,
              ),
            ),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Panel del coordinador', style: AppEstiloTexto.heading),
                  AppTamanos.gapV4,
                  Text(
                    'Hola, ${widget.userName}. Consulta la información académica de tu carrera.',
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
