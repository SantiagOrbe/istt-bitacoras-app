import 'package:flutter/material.dart';

import '../../../../../config/constants/app_colors.dart';
import '../../../../../config/constants/app_sizes.dart';
import '../../../../../config/theme/app_text_styles.dart';

class AccesoRapidoCard extends StatelessWidget {

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  const AccesoRapidoCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enabled=true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: enabled
                ? color.withValues(alpha: 0.15)
                : AppColors.outline,
          ),
          boxShadow: [
            BoxShadow(
              color: enabled
                  ? color.withValues(alpha: 0.10)
                  : AppColors.shadow,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 190;
            final iconBox = Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: enabled
                    ? color.withValues(alpha: 0.12)
                    : AppColors.disabledSurface,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: enabled ? color : AppColors.textDisabled,
              ),
            );
            final titleContent = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: enabled
                        ? AppColors.textPrimary
                        : AppColors.textDisabled,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.small.copyWith(
                      color: enabled
                          ? AppColors.textSecondary
                          : AppColors.textDisabled,
                    ),
                  ),
                ],
              ],
            );

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      iconBox,
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: enabled ? color : AppColors.textDisabled,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  titleContent,
                ],
              );
            }

            return Row(
              children: [
                iconBox,
                const SizedBox(width: AppSizes.sm),
                Expanded(child: titleContent),
                const SizedBox(width: AppSizes.sm),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: enabled ? color : AppColors.textDisabled,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}