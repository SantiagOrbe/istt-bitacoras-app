import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class ProgresoPracticasCard extends StatelessWidget {
  final String period;
  final num completedHours;
  final num totalHours;
  final VoidCallback? onPeriodTap;

  const ProgresoPracticasCard({
    super.key,
    required this.period,
    required this.completedHours,
    required this.totalHours,
    this.onPeriodTap,
  });

  @override
  Widget build(BuildContext context) {
    final double completedValue = completedHours.toDouble();
    final double totalValue = totalHours.toDouble();
    final double safeTotal = totalValue > 0 ? totalValue : 1.0;
    final double progress = (completedValue / safeTotal).clamp(0.0, 1.0);
    final int percentage = (progress * 100).toInt();

    return InstitutionalGlowCard(
      accentColor: progress >= 1 ? AppColores.success : AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector / Header de Período Académico
          InkWell(
            onTap: onPeriodTap,
            borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTamanos.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PERÍODO ACADÉMICO',
                    style: AppEstiloTexto.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColores.textSecondary,
                    ),
                  ),
                  AppTamanos.gapV4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: AppColores.primary,
                          ),
                          AppTamanos.gapH8,
                          Text(
                            period,
                            style: AppEstiloTexto.bodyBold.copyWith(
                              fontSize: 16,
                              color: AppColores.primary,
                            ),
                          ),
                        ],
                      ),
                      if (onPeriodTap != null)
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColores.textSecondary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          AppTamanos.gapV16,

          // Conteo de horas acumuladas vs total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HORAS REGISTRADAS',
                style: AppEstiloTexto.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: AppColores.textSecondary,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${completedValue.toStringAsFixed(1)} ',
                      style: AppEstiloTexto.bodyBold.copyWith(
                        fontSize: 16,
                        color: AppColores.primary,
                      ),
                    ),
                    TextSpan(
                      text: '/ ${totalValue.toStringAsFixed(0)} hrs',
                      style: AppEstiloTexto.caption.copyWith(
                        fontSize: 13,
                        color: AppColores.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppTamanos.gapV8,

          // Barra de progreso estilizada
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColores.outline.withValues(alpha: 0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColores.secondary,
              ),
            ),
          ),

          AppTamanos.gapV16,

          // Resumen textual con estado de avance
          Row(
            children: [
              Icon(
                progress >= 1
                    ? Icons.check_circle_rounded
                    : Icons.timelapse_rounded,
                size: 16,
                color: progress >= 1 ? AppColores.success : AppColores.primary,
              ),
              AppTamanos.gapH8,
              Expanded(
                child: Text(
                    progress >= 1
                      ? 'Has completado el 100% de tus prácticas.'
                      : 'Has completado el $percentage% de tus prácticas.',
                  style: AppEstiloTexto.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColores.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
