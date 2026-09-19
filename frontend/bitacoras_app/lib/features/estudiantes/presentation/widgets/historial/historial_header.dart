import 'package:bitacoras_app/shared/exports.dart';

class HistorialHeader extends StatelessWidget {
  final String semesterName;
  final int percentage;
  final double completedHours;
  final double totalHours;

  const HistorialHeader({
    super.key,
    this.semesterName = 'Semestre actual',
    this.percentage = 0,
    this.completedHours = 0,
    this.totalHours = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.sm + 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(
                  Icons.timeline_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              AppSizes.gapH16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avance de prácticas',
                      style: AppTextStyles.title.copyWith(
                        fontSize: 22,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      semesterName,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSizes.gapV16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentage% completado',
                style: AppTextStyles.bodyBold.copyWith(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${completedHours.toStringAsFixed(1)}h / ${totalHours.toStringAsFixed(0)}h',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
