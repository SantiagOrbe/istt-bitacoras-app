import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
import 'package:bitacoras_app/shared/exports.dart';

class CarreraConfigCard extends StatelessWidget {
  final CarreraModel career;
  final Set<int> activeSemesters;
  final ValueChanged<int> onToggleSemester;

  const CarreraConfigCard({
    super.key,
    required this.career,
    required this.activeSemesters,
    required this.onToggleSemester,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !career.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: isDisabled ? AppColors.disabledSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isDisabled ? AppColors.outline : AppColors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                color: isDisabled ? AppColors.textSecondary : AppColors.primary,
                size: 22,
              ),
              AppSizes.gapH8,
              Expanded(
                child: Text(
                  career.name,
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    color: isDisabled ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDisabled ? AppColors.outline : AppColors.infoSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isDisabled ? 'Inactiva' : 'Activa',
                  style: AppTextStyles.caption.copyWith(
                    color: isDisabled ? AppColors.textSecondary : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: Divider(color: AppColors.divider, height: 1),
          ),
          Text(
            isDisabled
                ? 'Esta carrera está inactiva y no puede seleccionar semestres para prácticas.'
                : 'Semestres habilitados para prácticas:',
            style: AppTextStyles.small.copyWith(
              color: isDisabled ? AppColors.textSecondary : AppColors.textPrimary,
            ),
          ),
          AppSizes.gapV16,
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: List.generate(career.totalSemesters, (i) {
              final semester = i + 1;
              final isSelected = activeSemesters.contains(semester);

              return InkWell(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                onTap: isDisabled ? null : () => onToggleSemester(semester),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? AppColors.disabledSurface
                        : (isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: isDisabled
                          ? AppColors.outline
                          : (isSelected ? AppColors.primary : AppColors.outline),
                      width: isSelected && !isDisabled ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected && !isDisabled) ...[
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        AppSizes.gapH4,
                      ],
                      Text(
                        '$semester° Semestre',
                        style: (isSelected && !isDisabled)
                            ? AppTextStyles.bodyBold.copyWith(
                                color: AppColors.primary,
                                fontSize: 13,
                              )
                            : AppTextStyles.body.copyWith(
                                fontSize: 13,
                                color: isDisabled ? AppColors.textSecondary : null,
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
