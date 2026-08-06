import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

class PdfFormatPreviewCard extends StatelessWidget {
  const PdfFormatPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.find_in_page_outlined,
            size: 40,
            color: AppColors.primary,
          ),
          AppSizes.gapV8,
          Text(
            'BITÁCORA DEL ESTUDIANTE',
            style: AppTextStyles.bodyBold.copyWith(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
          AppSizes.gapV4,
          Text(
            'FORMACIÓN PRÁCTICA EN EL ENTORNO LABORAL REAL',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}