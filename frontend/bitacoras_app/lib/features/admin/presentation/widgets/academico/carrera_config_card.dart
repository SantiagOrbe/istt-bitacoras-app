import 'package:bitacoras_app/features/admin/admin.dart';

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
      margin: const EdgeInsets.only(bottom: AppTamanos.md),
      padding: const EdgeInsets.all(AppTamanos.md),
      decoration: BoxDecoration(
        color: isDisabled ? AppColores.disabledSurface : AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
        border: Border.all(
          color: isDisabled
              ? AppColores.outline
              : AppColores.secondary.withValues(alpha: 0.35),
        ),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: AppColores.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? AppColores.outline
                      : AppColores.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: isDisabled
                      ? AppColores.textSecondary
                      : AppColores.primary,
                  size: 21,
                ),
              ),
              AppTamanos.gapH8,
              Expanded(
                child: Text(
                  career.name,
                  style: AppEstiloTexto.bodyBold.copyWith(
                    fontSize: 16,
                    color: isDisabled
                        ? AppColores.textSecondary
                        : AppColores.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDisabled
                      ? AppColores.disabledSurface
                      : AppColores.successSoft,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isDisabled
                        ? AppColores.outline
                        : AppColores.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  isDisabled ? 'Inactiva' : 'Activa',
                  style: AppEstiloTexto.caption.copyWith(
                    color: isDisabled
                        ? AppColores.textSecondary
                        : AppColores.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppTamanos.sm),
            child: Divider(color: AppColores.divider, height: 1),
          ),
          Text(
            isDisabled
                ? 'Esta carrera está inactiva y no puede seleccionar semestres para prácticas.'
                : 'Semestres habilitados para prácticas:',
            style: AppEstiloTexto.small.copyWith(
              color: isDisabled
                  ? AppColores.textSecondary
                  : AppColores.textPrimary,
            ),
          ),
          AppTamanos.gapV16,
          if (!isDisabled)
            Text(
              '${activeSemesters.length} de ${career.totalSemesters} semestres habilitados',
              style: AppEstiloTexto.caption.copyWith(
                color: AppColores.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (!isDisabled) AppTamanos.gapV8,
          Wrap(
            spacing: AppTamanos.sm,
            runSpacing: AppTamanos.sm,
            children: List.generate(career.totalSemesters, (i) {
              final semester = i + 1;
              final isSelected = activeSemesters.contains(semester);

              return InkWell(
                borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                onTap: isDisabled ? null : () => onToggleSemester(semester),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTamanos.md,
                    vertical: AppTamanos.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? AppColores.disabledSurface
                        : (isSelected
                              ? AppColores.secondary.withValues(alpha: 0.1)
                              : AppColores.background),
                    borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                    border: Border.all(
                      color: isDisabled
                          ? AppColores.outline
                          : (isSelected
                                ? AppColores.primary
                                : AppColores.outline),
                      width: isSelected && !isDisabled ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected && !isDisabled) ...[
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColores.primary,
                          size: 16,
                        ),
                        AppTamanos.gapH4,
                      ],
                      Text(
                        '$semester° Semestre',
                        style: (isSelected && !isDisabled)
                            ? AppEstiloTexto.bodyBold.copyWith(
                                color: AppColores.primary,
                                fontSize: 13,
                              )
                            : AppEstiloTexto.body.copyWith(
                                fontSize: 13,
                                color: isDisabled
                                    ? AppColores.textSecondary
                                    : null,
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
