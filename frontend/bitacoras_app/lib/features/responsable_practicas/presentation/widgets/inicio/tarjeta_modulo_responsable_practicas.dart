import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class ModuloResponsablePracticas {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accentColor;

  const ModuloResponsablePracticas({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.accentColor,
  });
}

class TarjetaModuloResponsablePracticas extends StatelessWidget {
  final ModuloResponsablePracticas module;
  final VoidCallback onTap;

  const TarjetaModuloResponsablePracticas({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: module.accentColor,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Row(
          children: [
            Icon(module.icon, color: module.accentColor, size: 28),
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
                    style: AppEstiloTexto.bodyBold,
                  ),
                  AppTamanos.gapV4,
                  Text(
                    module.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppEstiloTexto.caption,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColores.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
