import '../exports.dart';

class InstitutionalGlowCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color accentColor;

  const InstitutionalGlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor = AppColors.primary,
  });

  @override
  State<InstitutionalGlowCard> createState() => _InstitutionalGlowCardState();
}

class _InstitutionalGlowCardState extends State<InstitutionalGlowCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusMd);
    final glow = widget.accentColor.withValues(alpha: _isHovered ? 0.22 : 0.12);

    return MouseRegion(
      cursor: widget.onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.infoSoft.withValues(alpha: 0.85),
            ],
          ),
          border: Border.all(color: glow, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: glow,
              blurRadius: _isHovered ? 20 : 12,
              spreadRadius: _isHovered ? 1 : 0.2,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
              color: AppColors.shadow,
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: radius,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.accentColor, AppColors.secondary],
                        ),
                      ),
                    ),
                  ),
                  widget.child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
