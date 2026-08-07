import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

class PracticeProgressCard extends StatelessWidget {
  final String period;
  final int completedHours;
  final int totalHours;
  final VoidCallback? onPeriodTap;

  const PracticeProgressCard({
    super.key,
    required this.period,
    required this.completedHours,
    required this.totalHours,
    this.onPeriodTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculamos el progreso de forma segura evitando división por cero
    final double safeTotal = totalHours > 0 ? totalHours.toDouble() : 1.0;
    final double progress = (completedHours / safeTotal).clamp(0.0, 1.0);
    final int percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.outline),
      ),
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
                      text: '$completedHours ',
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: '/ $totalHours hrs',
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
              backgroundColor: AppColors.outline.withOpacity(0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
          ),

          AppSizes.gapV16,

          // Resumen textual con estado de avance
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.success,
              ),
              AppSizes.gapH8,
              Expanded(
                child: Text(
                  'Has completado el $percentage% de tus prácticas.',
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
    );
  }
}