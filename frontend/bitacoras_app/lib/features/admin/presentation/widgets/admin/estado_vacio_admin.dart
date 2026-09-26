import 'package:bitacoras_app/features/admin/admin.dart';

class EstadoVacioAdmin extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const EstadoVacioAdmin({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTamanos.lg),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: accentColor),
          ),
          AppTamanos.gapV16,
          Text(
            title,
            style: AppEstiloTexto.bodyBold.copyWith(
              color: AppColores.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppTamanos.gapV8,
          Text(
            subtitle,
            style: AppEstiloTexto.caption.copyWith(
              color: AppColores.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
