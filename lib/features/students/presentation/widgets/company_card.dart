import 'package:bitacoras_app/shared/exports.dart';

class CompanyCard extends StatelessWidget {
  final String companyName;

  const CompanyCard({
    super.key,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const Icon(Icons.business, color: AppColors.primary),
          AppSizes.gapH12,
          Expanded(
            child: Text(
              companyName,
              style: AppTextStyles.bodyBold,
            ),
          ),
        ],
      ),
    );
  }
}