import 'package:bitacoras_app/features/admin/admin.dart';

class AcademicoScreenHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? count;
  final Widget? child;

  const AcademicoScreenHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.count,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTamanos.md,
        AppTamanos.md,
        AppTamanos.md,
        AppTamanos.sm,
      ),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
        border: Border.all(color: AppColores.outline),
        boxShadow: [
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColores.secondary, AppColores.warning],
                  ),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                ),
                child: Icon(icon, color: AppColores.surface),
              ),
              AppTamanos.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppEstiloTexto.title),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: AppEstiloTexto.caption.copyWith(
                          color: AppColores.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (count != null)
                Text(
                  count!,
                  style: AppEstiloTexto.heading.copyWith(
                    color: AppColores.primary,
                    fontSize: 22,
                  ),
                ),
            ],
          ),
          if (child != null) ...[AppTamanos.gapV16, child!],
        ],
      ),
    );
  }
}

class AcademicoFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const AcademicoFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppTamanos.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColores.primary.withValues(alpha: 0.12),
        backgroundColor: AppColores.surface,
        labelStyle: AppEstiloTexto.body.copyWith(
          color: selected ? AppColores.primary : AppColores.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? AppColores.primary : AppColores.outline,
        ),
      ),
    );
  }
}
