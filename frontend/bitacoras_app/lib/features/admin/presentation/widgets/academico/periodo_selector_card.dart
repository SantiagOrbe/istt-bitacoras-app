import 'package:bitacoras_app/features/admin/admin.dart';


class PeriodoSelectorCard extends StatelessWidget {
  final List<PeriodoModel> periods;
  final String selectedPeriodId;
  final ValueChanged<String?> onChanged;

  const PeriodoSelectorCard({
    super.key,
    required this.periods,
    required this.selectedPeriodId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activePeriods = periods.where((p) => p.isActive).toList();
    final bool valueExists = activePeriods.any((p) => p.id == selectedPeriodId);
    final String? effectiveValue = valueExists
        ? selectedPeriodId
        : (activePeriods.isNotEmpty ? activePeriods.first.id : null);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            AppSizes.gapH8,
            Text('Período lectivo', style: AppTextStyles.bodyBold),
            AppSizes.gapH8,
            Expanded(
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(color: AppColors.outline),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: effectiveValue,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.primary,
                    ),
                    style: AppTextStyles.bodyMedium,
                    items: activePeriods.isEmpty
                        ? [
                            const DropdownMenuItem<String>(
                              value: null,
                              enabled: false,
                              child: Text('No hay periodos activos'),
                            ),
                          ]
                        : activePeriods.map((p) {
                            return DropdownMenuItem<String>(
                              value: p.id,
                              child: Text(
                                p.name,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyBold.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                    onChanged: activePeriods.isEmpty ? null : onChanged,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
