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
      accentColor: progress >= 1 ? AppColors.success : AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector / Header de Período Académico
          InkWell(
            onTap: onPeriodTap,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PERÍODO ACADÉMICO',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          AppSizes.gapH8,
                          Text(
                            period,
                            style: AppTextStyles.bodyBold.copyWith(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      if (onPeriodTap != null)
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          AppSizes.gapV16,

          // Conteo de horas acumuladas vs total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HORAS REGISTRADAS',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${completedValue.toStringAsFixed(1)} ',
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: '/ ${totalValue.toStringAsFixed(0)} hrs',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppSizes.gapV8,

          // Barra de progreso estilizada
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.outline.withValues(alpha: 0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
            ),
          ),

          AppSizes.gapV16,

          // Resumen textual con estado de avance
          Row(
            children: [
              Icon(
                progress >= 1
                    ? Icons.check_circle_rounded
                    : Icons.timelapse_rounded,
                size: 16,
                color: progress >= 1 ? AppColors.success : AppColors.primary,
              ),
              AppSizes.gapH8,
              Expanded(
                child: Text(
                    progress >= 1
                      ? 'Has completado el 100% de tus prácticas.'
                      : 'Has completado el $percentage% de tus prácticas.',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
