import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class ReportesHeader extends StatelessWidget {
  const ReportesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            const Icon(Icons.assessment_outlined, color: AppColors.primary, size: 28),
            AppSizes.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reportes y bitácoras',
                    style: AppTextStyles.title.copyWith(
                      fontSize: 22,
                      color: AppColors.primary,
                    ),
                  ),
                  AppSizes.gapV4,
                  Text(
                    'Consulta tu avance y genera el documento institucional.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
