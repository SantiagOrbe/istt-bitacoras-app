import 'package:go_router/go_router.dart';

import 'package:bitacoras_app/shared/exports.dart';

class TutorDashboardContent extends StatelessWidget {
  final UsuarioModel user;
  final String title;
  final String description;
  final String? summary;
  final List<TutorModule> modules;

  const TutorDashboardContent({
    super.key,
    required this.user,
    required this.title,
    required this.description,
    required this.modules,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTamanos.md),
          children: [
            TutorDashboardHero(
              userName: user.name,
              title: title,
              description: description,
            ),
            if (summary != null) ...[
              AppTamanos.gapV12,
              Text(summary!, style: AppEstiloTexto.bodyBold),
            ],
            AppTamanos.gapV20,
            Text('Accesos de gestión', style: AppEstiloTexto.title),
            AppTamanos.gapV12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: AppTamanos.sm,
                mainAxisSpacing: AppTamanos.sm,
                childAspectRatio: isWide ? 1.55 : 1.0,
              ),
              itemBuilder: (context, index) {
                final module = modules[index];
                return TutorModuleCard(
                  module: module,
                  onTap: module.enabled ? () => context.push(module.route) : null,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class TutorDashboardHero extends StatelessWidget {
  final String userName;
  final String title;
  final String description;

  const TutorDashboardHero({
    super.key,
    required this.userName,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColores.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
              ),
              child: const WavingHand(color: AppColores.primary, size: 28),
            ),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppEstiloTexto.heading),
                  AppTamanos.gapV4,
                  Text(
                    'Hola, $userName. $description',
                    style: AppEstiloTexto.body.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorModuleCard extends StatelessWidget {
  final TutorModule module;
  final VoidCallback? onTap;

  const TutorModuleCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = module.enabled ? module.accentColor : AppColores.textSecondary;
    return InstitutionalGlowCard(
      accentColor: color,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Row(
          children: [
            Icon(module.icon, color: color, size: 28),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppEstiloTexto.bodyBold.copyWith(color: color),
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
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}

class TutorDashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const TutorDashboardError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: AppColores.error, size: 42),
            AppTamanos.gapV12,
            Text(message, textAlign: TextAlign.center, style: AppEstiloTexto.body),
            AppTamanos.gapV12,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accentColor;
  final bool enabled;

  const TutorModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.accentColor,
    this.enabled = true,
  });
}
