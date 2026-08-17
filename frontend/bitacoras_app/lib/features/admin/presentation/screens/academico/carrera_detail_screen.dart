import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';

class CarreraDetailScreen extends StatelessWidget {
  final UsuarioModel currentUser;
  final CarreraModel career;

  const CarreraDetailScreen({
    super.key,
    required this.currentUser,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: currentUser,
        showBackButton: true,
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_tree_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
                AppSizes.gapV12,
                Text(
                  career.name,
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSizes.gapV8,
                Text(
                  'ID: ${career.id}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSizes.gapV16,
                _InfoRow(
                  label: 'Código',
                  value: career.code,
                ),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Sigla',
                  value: career.shortName,
                ),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Modalidad',
                  value: career.modality,
                ),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Semestres totales',
                  value: career.totalSemesters.toString(),
                ),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Estado',
                  value: career.isActive ? 'Activa' : 'Inactiva',
                ),
                AppSizes.gapV8,
                Text(
                  career.description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
