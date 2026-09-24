import 'package:bitacoras_app/features/admin/admin.dart';


class CicloCard extends StatelessWidget {
  final CicloModel cycle;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;
  final VoidCallback? onEdit;

  const CicloCard({
    super.key,
    required this.cycle,
    required this.onTap,
    required this.onToggleStatus,
    this.onEdit,
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
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.16),
                  ),
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
                    AppSizes.gapV4,
                    Text(
                      cycle.isActive ? 'Periodo habilitado' : 'Periodo suspendido',
                      style: AppTextStyles.caption.copyWith(
                        color: cycle.isActive
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSizes.gapV4,
                    Text(
                      'Prácticas: ${cycle.hoursPracticas} h',
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
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      tooltip: 'Editar semestre',
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  Switch.adaptive(
                    value: cycle.isActive,
                    onChanged: (_) => onToggleStatus(),
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
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
