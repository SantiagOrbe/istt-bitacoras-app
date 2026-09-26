import 'package:bitacoras_app/features/admin/admin.dart';

class ChipEstadoAdmin extends StatelessWidget {
  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;

  const ChipEstadoAdmin({
    super.key,
    required this.isActive,
    this.activeLabel = 'Activo',
    this.inactiveLabel = 'Inactivo',
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColores.success : AppColores.error;
    final label = isActive ? activeLabel : inactiveLabel;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTamanos.sm,
        vertical: AppTamanos.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
      ),
      child: Text(
        label,
        style: AppEstiloTexto.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
