import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

class PerfilHeaderCard extends StatelessWidget {
  final UsuarioModel user;

  const PerfilHeaderCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = user.name.isNotEmpty ? user.name : 'Usuario';
    final initialLetter = displayName[0].toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar con borde Verde Institucional
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.primary,
              child: Text(
                initialLetter,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.surface,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          AppSizes.gapV12,

          // Nombre del Usuario
          Text(
            displayName,
            style: AppTextStyles.title.copyWith(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSizes.gapV8,

          // Badge con el Rol
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warningSoft,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.warning),
            ),
            child: Text(
              user.role.name.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Empresa Asignada con control de desborde (Evita el RenderFlex Overflow)
          if (user.company?.isNotEmpty ?? false) ...[
            AppSizes.gapV12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    user.company!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}