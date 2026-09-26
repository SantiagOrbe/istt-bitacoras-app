import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class EmpresaCard extends StatelessWidget {
  final String companyName;

  const EmpresaCard({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.secondary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColores.secondary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
              ),
              child: const Icon(
                Icons.business_rounded,
                color: AppColores.primary,
                size: 20,
              ),
            ),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Empresa asignada',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                  AppTamanos.gapV4,
                  Text(
                    companyName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppEstiloTexto.bodyBold,
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
