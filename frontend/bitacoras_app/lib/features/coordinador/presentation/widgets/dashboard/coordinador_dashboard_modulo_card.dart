import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorDashboardModulo {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accentColor;

  const CoordinadorDashboardModulo(
    this.title,
    this.subtitle,
    this.icon,
    this.route,
    this.accentColor,
  );
}

class CoordinadorDashboardModuloCard extends StatelessWidget {
  final CoordinadorDashboardModulo module;
  final VoidCallback onTap;

  const CoordinadorDashboardModuloCard({
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
