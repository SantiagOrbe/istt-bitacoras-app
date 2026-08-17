import 'package:bitacoras_app/features/admin/domain/models/ciclo_model.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/admin_status_chip.dart';
import 'package:bitacoras_app/shared/exports.dart';

class CicloCard extends StatelessWidget {
  final CicloModel cycle;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;

  const CicloCard({
    super.key,
    required this.cycle,
    required this.onTap,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.primary,
                ),
              ),
              AppSizes.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cycle.name,
                      style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
                    ),
                    AppSizes.gapV4,
                    Text(
                      'Nivel ${cycle.level}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSizes.gapV8,
                    AdminStatusChip(isActive: cycle.isActive),
                  ],
                ),
              ),
              AppSizes.gapH8,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch.adaptive(
                    value: cycle.isActive,
                    onChanged: (_) => onToggleStatus(),
                    activeColor: AppColors.primary,
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
