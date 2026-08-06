import 'package:flutter/material.dart';
import 'package:bitacoras_app/features/admin/domain/models/period_model.dart';
import 'package:bitacoras_app/shared/exports.dart';

class PeriodSelectorCard extends StatelessWidget {
  final List<PeriodModel> periods;
  final String selectedPeriodId;
  final ValueChanged<String?> onChanged;

  const PeriodSelectorCard({
    super.key,
    required this.periods,
    required this.selectedPeriodId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Validación de seguridad para el valor seleccionado en el Dropdown
    final bool valueExists = periods.any((p) => p.id == selectedPeriodId);
    final String? effectiveValue = valueExists ? selectedPeriodId : (periods.isNotEmpty ? periods.first.id : null);

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
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            AppSizes.gapH8,
            Text('Periodo:', style: AppTextStyles.bodyBold),
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
                    items: periods.map((p) {
                      return DropdownMenuItem<String>(
                        value: p.id,
                        child: Text(
                          p.name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
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