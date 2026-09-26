import 'package:bitacoras_app/features/estudiantes/presentation/widgets/inicio/estudiante_dashboard_modulo.dart';
import 'package:bitacoras_app/shared/exports.dart';

class EstudianteDashboardModuloCard extends StatelessWidget {
  final EstudianteDashboardModulo module;
  final VoidCallback? onTap;

  const EstudianteDashboardModuloCard({
    super.key,
    required this.module,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = module.enabled;
    final color = isEnabled ? module.accentColor : AppColores.textSecondary;
    final surfaceColor = isEnabled
        ? module.accentColor.withValues(alpha: 0.08)
        : AppColores.surface;
    final borderColor = isEnabled
        ? module.accentColor.withValues(alpha: 0.45)
        : AppColores.outline;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
        border: Border.all(color: borderColor, width: isEnabled ? 1.4 : 1.0),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: module.accentColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppTamanos.md),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? module.accentColor.withValues(alpha: 0.12)
                        : AppColores.disabledSurface,
                    borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                  ),
                  child: Icon(module.icon, color: color, size: 22),
                ),
                AppTamanos.gapH12,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppEstiloTexto.bodyBold.copyWith(color: color),
                      ),
                      AppTamanos.gapV4,
                      Text(
                        module.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppEstiloTexto.caption.copyWith(
                          color: isEnabled
                              ? AppColores.textSecondary
                              : AppColores.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
