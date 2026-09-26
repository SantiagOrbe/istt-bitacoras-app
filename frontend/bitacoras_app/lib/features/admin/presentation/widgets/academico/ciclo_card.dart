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
                  color: AppColores.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                  border: Border.all(
                    color: AppColores.primary.withValues(alpha: 0.16),
                  ),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColores.primary,
                ),
              ),
              AppTamanos.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cycle.name,
                      style: AppEstiloTexto.bodyBold.copyWith(fontSize: 15),
                    ),
                    AppTamanos.gapV4,
                    Text(
                      'Nivel ${cycle.level}',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                      ),
                    ),
                    AppTamanos.gapV4,
                    Text(
                      cycle.isActive
                          ? 'Periodo habilitado'
                          : 'Periodo suspendido',
                      style: AppEstiloTexto.caption.copyWith(
                        color: cycle.isActive
                            ? AppColores.success
                            : AppColores.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppTamanos.gapV4,
                    Text(
                      'Prácticas: ${cycle.hoursPracticas} h',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                      ),
                    ),
                    AppTamanos.gapV8,
                    ChipEstadoAdmin(isActive: cycle.isActive),
                  ],
                ),
              ),
              AppTamanos.gapH8,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      tooltip: 'Editar semestre',
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColores.primary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  Switch.adaptive(
                    value: cycle.isActive,
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
}
