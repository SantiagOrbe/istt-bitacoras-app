import 'package:bitacoras_app/features/admin/admin.dart';

class PeriodoCard extends StatelessWidget {
  final PeriodoModel period;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;

  const PeriodoCard({
    super.key,
    required this.period,
    required this.onTap,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColores.surface,
      borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTamanos.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
            border: Border.all(color: AppColores.outline),
            boxShadow: [
              BoxShadow(
                color: AppColores.shadow,
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
                  color: AppColores.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                  border: Border.all(
                    color: AppColores.secondary.withValues(alpha: 0.22),
                  ),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColores.secondary,
                ),
              ),
              AppTamanos.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      period.name,
                      style: AppEstiloTexto.bodyBold.copyWith(fontSize: 15),
                    ),
                    AppTamanos.gapV4,
                    Text(
                      '${_formatDate(period.startDate)} - ${_formatDate(period.endDate)}',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                      ),
                    ),
                    AppTamanos.gapV8,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTamanos.sm,
                        vertical: AppTamanos.xs,
                      ),
                      decoration: BoxDecoration(
                        color: period.isActive
                            ? AppColores.successSoft
                            : AppColores.errorSoft,
                        borderRadius: BorderRadius.circular(
                          AppTamanos.radiusSm,
                        ),
                        border: Border.all(
                          color: period.isActive
                              ? AppColores.success.withValues(alpha: 0.35)
                              : AppColores.error.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        period.isActive ? 'Activo' : 'Inactivo',
                        style: AppEstiloTexto.caption.copyWith(
                          color: period.isActive
                              ? AppColores.success
                              : AppColores.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppTamanos.gapH8,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch.adaptive(
                    value: period.isActive,
                    onChanged: (_) => onToggleStatus(),
                    activeThumbColor: AppColores.primary,
                    activeTrackColor: AppColores.primary.withValues(
                      alpha: 0.35,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColores.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
