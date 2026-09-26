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
        horizontal: AppTamanos.md,
        vertical: AppTamanos.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTamanos.md,
          vertical: AppTamanos.sm,
        ),
        decoration: BoxDecoration(
          color: AppColores.surface,
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          border: Border.all(color: AppColores.outline),
          boxShadow: [
            BoxShadow(
              color: AppColores.shadow,
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
                color: AppColores.secondary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                color: AppColores.secondary,
                size: 20,
              ),
            ),
            AppTamanos.gapH8,
            Text('Período lectivo', style: AppEstiloTexto.bodyBold),
            AppTamanos.gapH8,
            Expanded(
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: AppTamanos.sm),
                decoration: BoxDecoration(
                  color: AppColores.background,
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                  border: Border.all(color: AppColores.outline),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: effectiveValue,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColores.primary,
                    ),
                    style: AppEstiloTexto.bodyMedium,
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
                                style: AppEstiloTexto.bodyBold.copyWith(
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
