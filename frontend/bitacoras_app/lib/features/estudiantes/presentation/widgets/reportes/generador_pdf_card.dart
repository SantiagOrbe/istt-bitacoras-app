import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class GeneradorPdfCard extends StatelessWidget {
  final VoidCallback onGeneratePressed;

  const GeneradorPdfCard({super.key, required this.onGeneratePressed});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: const Icon(
                    Icons.article_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                AppSizes.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bitácora oficial de prácticas',
                        style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
                      ),
                      AppSizes.gapV4,
                      Text(
                        'Genera el documento consolidado de tus actividades registradas.',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSizes.gapV16,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                onPressed: onGeneratePressed,
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: Text(
                  'Generar y descargar PDF',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ),
            ),
            AppSizes.gapV8,
            Text(
              'El documento se genera con tus registros reales de prácticas.',
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
