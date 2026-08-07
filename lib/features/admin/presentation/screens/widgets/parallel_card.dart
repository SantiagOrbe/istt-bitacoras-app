import 'package:bitacoras_app/features/admin/domain/models/parallel_model.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/admin_status_chip.dart';
import 'package:bitacoras_app/shared/exports.dart';

class ParallelCard extends StatelessWidget {
  final ParallelModel parallel;
  final String cycleName;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;

  const ParallelCard({
    super.key,
    required this.parallel,
    required this.cycleName,
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
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: AppColors.secondary,
                ),
              ),
              AppSizes.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paralelo ${parallel.name}',
                      style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
                    ),
                    AppSizes.gapV4,
                    Text(
                      '$cycleName • ${parallel.jornada}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSizes.gapV8,
                    AdminStatusChip(isActive: parallel.isActive),
                  ],
                ),
              ),
              AppSizes.gapH8,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch.adaptive(
                    value: parallel.isActive,
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
