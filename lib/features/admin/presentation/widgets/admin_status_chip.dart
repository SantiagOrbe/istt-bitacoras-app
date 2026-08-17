import 'package:bitacoras_app/shared/exports.dart';

class AdminStatusChip extends StatelessWidget {
  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;

  const AdminStatusChip({
    super.key,
    required this.isActive,
    this.activeLabel = 'Activo',
    this.inactiveLabel = 'Inactivo',
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.error;
    final label = isActive ? activeLabel : inactiveLabel;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
