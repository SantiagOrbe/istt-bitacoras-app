import 'package:bitacoras_app/features/perfiles/perfiles.dart';

class PerfilInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PerfilInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColores.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
              ),
              child: Icon(
                icon,
                color: AppColores.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppTamanos.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value.isNotEmpty ? value : 'Sin especificar',
                    style: AppEstiloTexto.bodyBold.copyWith(
                      color: AppColores.textPrimary,
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