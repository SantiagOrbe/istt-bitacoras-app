import 'package:bitacoras_app/features/admin/admin.dart';


class ParaleloCard extends StatelessWidget {
  final ParaleloModel parallel;
  final String cycleName;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;
  final VoidCallback onAssignStudents;
  final VoidCallback onRemoveStudents;

  const ParaleloCard({
    super.key,
    required this.parallel,
    required this.cycleName,
    required this.onTap,
    required this.onToggleStatus,
    required this.onAssignStudents,
    required this.onRemoveStudents,
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
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.22),
                  ),
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
                    AppSizes.gapV4,
                    Text(
                      parallel.isActive
                          ? 'Gestión habilitada'
                          : 'Gestión suspendida',
                      style: AppTextStyles.caption.copyWith(
                        color: parallel.isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
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
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
                  ),
                  IconButton(
                    tooltip: 'Agregar estudiantes',
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    onPressed: onAssignStudents,
                  ),
                  IconButton(
                    tooltip: 'Retirar todos los estudiantes',
                    icon: const Icon(Icons.person_remove_outlined),
                    color: AppColors.error,
                    onPressed: onRemoveStudents,
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
