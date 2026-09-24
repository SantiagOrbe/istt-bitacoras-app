import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class EmpresaCard extends StatelessWidget {
  final String companyName;

  const EmpresaCard({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(
                Icons.business_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            AppSizes.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Empresa asignada',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV4,
                  Text(
                    companyName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold,
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
