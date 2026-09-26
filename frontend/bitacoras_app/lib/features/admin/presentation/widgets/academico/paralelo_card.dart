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
                  Icons.groups_rounded,
                  color: AppColores.secondary,
                ),
              ),
              AppTamanos.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paralelo ${parallel.name}',
                      style: AppEstiloTexto.bodyBold.copyWith(fontSize: 15),
                    ),
                    AppTamanos.gapV4,
                    Text(
                      '$cycleName • ${parallel.jornada}',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppTamanos.gapV4,
                    Text(
                      parallel.isActive
                          ? 'Gestión habilitada'
                          : 'Gestión suspendida',
                      style: AppEstiloTexto.caption.copyWith(
                        color: parallel.isActive
                            ? AppColores.primary
                            : AppColores.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppTamanos.gapV8,
                    ChipEstadoAdmin(isActive: parallel.isActive),
                  ],
                ),
              ),
              AppTamanos.gapH8,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch.adaptive(
                    value: parallel.isActive,
                    onChanged: (_) => onToggleStatus(),
                    activeThumbColor: AppColores.primary,
                    activeTrackColor: AppColores.primary.withValues(
                      alpha: 0.35,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Agregar estudiantes',
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    onPressed: onAssignStudents,
                  ),
                  IconButton(
                    tooltip: 'Retirar todos los estudiantes',
                    icon: const Icon(Icons.person_remove_outlined),
                    color: AppColores.error,
                    onPressed: onRemoveStudents,
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
