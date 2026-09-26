import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class GeneradorPdfCard extends StatelessWidget {
  final VoidCallback onGeneratePressed;

  const GeneradorPdfCard({super.key, required this.onGeneratePressed});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColores.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                  ),
                  child: const Icon(
                    Icons.article_outlined,
                    color: AppColores.primary,
                    size: 28,
                  ),
                ),
                AppTamanos.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bitácora oficial de prácticas',
                        style: AppEstiloTexto.bodyBold.copyWith(fontSize: 15),
                      ),
                      AppTamanos.gapV4,
                      Text(
                        'Genera el documento consolidado de tus actividades registradas.',
                        style: AppEstiloTexto.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppTamanos.gapV16,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColores.primary,
                  foregroundColor: AppColores.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                  ),
                ),
                onPressed: onGeneratePressed,
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: Text(
                  'Generar y descargar PDF',
                  style: AppEstiloTexto.bodyBold.copyWith(
                    color: AppColores.surface,
                  ),
                ),
              ),
            ),
            AppTamanos.gapV8,
            Text(
              'El documento se genera con tus registros reales de prácticas.',
              style: AppEstiloTexto.caption.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
