import 'package:bitacoras_app/shared/exports.dart';

class PeriodEmptyState extends StatelessWidget {
  final bool hasSearchQuery;

  const PeriodEmptyState({
    super.key,
    required this.hasSearchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final title = hasSearchQuery
        ? 'No se encontraron períodos'
        : 'Aún no hay períodos lectivos';
    final subtitle = hasSearchQuery
        ? 'Prueba con otro criterio de búsqueda.'
        : 'Crea el primer período lectivo para comenzar.';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              size: 40,
              color: AppColors.secondary,
            ),
          ),
          AppSizes.gapV16,
          Text(
            title,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSizes.gapV8,
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
