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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: _estaSobre ? AppColors.secondary : AppColors.outline,
          ),
          boxShadow: _estaSobre
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.14),
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
                    colors: [AppColors.secondary, AppColors.warning],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: InkWell(
                onTap: widget.onTap,
                hoverColor: AppColors.secondary.withValues(alpha: 0.05),
                splashColor: AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        child: Icon(
                          Icons.account_tree_rounded,
                          color: _estaSobre
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                      ),
                      AppSizes.gapH12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              career.name,
                              style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppSizes.gapV4,
                            Text(
                              '${career.shortName} • ${career.modality} • ${career.totalSemesters} semestres',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      AppSizes.gapH8,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: career.isActive
                              ? AppColors.successSoft
                              : AppColors.errorSoft,
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          border: Border.all(
                            color: career.isActive
                                ? AppColors.success.withValues(alpha: 0.35)
                                : AppColors.error.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          career.isActive ? 'Activa' : 'Inactiva',
                          style: AppTextStyles.caption.copyWith(
                            color: career.isActive
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AppSizes.gapH8,
                      Icon(
                        Icons.chevron_right_rounded,
                        color: _estaSobre
                            ? AppColors.primary
                            : AppColors.textSecondary,
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
