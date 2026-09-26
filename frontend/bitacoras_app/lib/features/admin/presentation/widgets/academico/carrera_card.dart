import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraCard extends StatefulWidget {
  final CarreraModel career;
  final VoidCallback onTap;

  const CarreraCard({super.key, required this.career, required this.onTap});

  @override
  State<CarreraCard> createState() => _CarreraCardState();
}

class _CarreraCardState extends State<CarreraCard> {
  bool _estaSobre = false;

  @override
  Widget build(BuildContext context) {
    final career = widget.career;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _estaSobre = true),
      onExit: (_) => setState(() => _estaSobre = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _estaSobre ? -1 : 0, 0),
        decoration: BoxDecoration(
          color: AppColores.surface,
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          border: Border.all(
            color: _estaSobre ? AppColores.secondary : AppColores.outline,
          ),
          boxShadow: _estaSobre
              ? [
                  BoxShadow(
                    color: AppColores.secondary.withValues(alpha: 0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColores.secondary, AppColores.warning],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
              child: InkWell(
                onTap: widget.onTap,
                hoverColor: AppColores.secondary.withValues(alpha: 0.05),
                splashColor: AppColores.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.all(AppTamanos.md),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColores.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppTamanos.radiusMd,
                          ),
                        ),
                        child: Icon(
                          Icons.account_tree_rounded,
                          color: _estaSobre
                              ? AppColores.secondary
                              : AppColores.primary,
                        ),
                      ),
                      AppTamanos.gapH12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              career.name,
                              style: AppEstiloTexto.bodyBold.copyWith(
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppTamanos.gapV4,
                            Text(
                              '${career.shortName} • ${career.modality} • ${career.totalSemesters} semestres',
                              style: AppEstiloTexto.caption.copyWith(
                                color: AppColores.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      AppTamanos.gapH8,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTamanos.sm,
                          vertical: AppTamanos.xs,
                        ),
                        decoration: BoxDecoration(
                          color: career.isActive
                              ? AppColores.successSoft
                              : AppColores.errorSoft,
                          borderRadius: BorderRadius.circular(
                            AppTamanos.radiusSm,
                          ),
                          border: Border.all(
                            color: career.isActive
                                ? AppColores.success.withValues(alpha: 0.35)
                                : AppColores.error.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          career.isActive ? 'Activa' : 'Inactiva',
                          style: AppEstiloTexto.caption.copyWith(
                            color: career.isActive
                                ? AppColores.success
                                : AppColores.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AppTamanos.gapH8,
                      Icon(
                        Icons.chevron_right_rounded,
                        color: _estaSobre
                            ? AppColores.primary
                            : AppColores.textSecondary,
                      ),
                    ],
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
