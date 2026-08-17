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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
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
              const Icon(
                Icons.school_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              AppSizes.gapH8,
              Expanded(
                child: Text(
                  career.name,
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: Divider(color: AppColors.divider, height: 1),
          ),
          Text(
            'Semestres habilitados para prácticas:',
            style: AppTextStyles.small,
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
                onTap: () => onToggleSemester(semester),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outline,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        AppSizes.gapH4,
                      ],
                      Text(
                        '$semester° Semestre',
                        style: isSelected
                            ? AppTextStyles.bodyBold.copyWith(
                                color: AppColors.primary,
                                fontSize: 13,
                              )
                            : AppTextStyles.body.copyWith(fontSize: 13),
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