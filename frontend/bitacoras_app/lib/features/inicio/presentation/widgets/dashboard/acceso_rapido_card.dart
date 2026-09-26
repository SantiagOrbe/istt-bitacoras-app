import 'package:flutter/material.dart';

import '../../../../../config/constants/app_colores.dart';
import '../../../../../config/constants/app_tamanos.dart';
import '../../../../../config/theme/app_estilo_texto.dart';

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
      borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppTamanos.md),
        decoration: BoxDecoration(
          color: AppColores.surface,
          borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
          border: Border.all(
            color: enabled
                ? color.withValues(alpha: 0.15)
                : AppColores.outline,
          ),
          boxShadow: [
            BoxShadow(
              color: enabled
                  ? color.withValues(alpha: 0.10)
                  : AppColores.shadow,
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
                    : AppColores.disabledSurface,
                borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
              ),
              child: Icon(
                icon,
                color: enabled ? color : AppColores.textDisabled,
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
                  style: AppEstiloTexto.bodyBold.copyWith(
                    color: enabled
                        ? AppColores.textPrimary
                        : AppColores.textDisabled,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppEstiloTexto.small.copyWith(
                      color: enabled
                          ? AppColores.textSecondary
                          : AppColores.textDisabled,
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
                        color: enabled ? color : AppColores.textDisabled,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTamanos.sm),
                  titleContent,
                ],
              );
            }

            return Row(
              children: [
                iconBox,
                const SizedBox(width: AppTamanos.sm),
                Expanded(child: titleContent),
                const SizedBox(width: AppTamanos.sm),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: enabled ? color : AppColores.textDisabled,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}