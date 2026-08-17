import 'package:bitacoras_app/shared/exports.dart';

class CarreraEmptyState extends StatelessWidget {
  final bool hasSearchQuery;

  const CarreraEmptyState({
    super.key,
    required this.hasSearchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final title = hasSearchQuery ? 'No se encontraron carreras' : 'Aún no hay carreras registradas';
    final subtitle = hasSearchQuery
        ? 'Intenta con otro criterio de búsqueda.'
        : 'Agrega la primera carrera para comenzar con la gestión.';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_tree_rounded,
              size: 40,
              color: AppColors.primary,
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
