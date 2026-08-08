import 'package:bitacoras_app/shared/exports.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.assignment_late_outlined,
            size: 40,
            color: AppColors.textSecondary,
          ),
          AppSizes.gapV8,
          Text(
            'No hay registros anteriores',
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}