import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

Future<void> showGpsErrorDialog(
  BuildContext context, {
  required String distanceText,
  VoidCallback? onRetry,
  VoidCallback? onCancel,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      backgroundColor: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono de Ubicación Deshabilitada / Fuera de Rango
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.error.withOpacity(0.12),
              child: const Icon(
                Icons.location_off_rounded,
                color: AppColors.error,
                size: 36,
              ),
            ),
            
            AppSizes.gapV16,
            
            Text(
              '¡UPS! Ubicación no válida',
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: AppColors.error,
                fontSize: 18,
              ),
            ),
            
            AppSizes.gapV8,
            
            Text(
              'Su ubicación actual no está dentro del rango permitido para la empresa/institución asignada.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            
            AppSizes.gapV16,

            // Badge de Distancia Dinámica
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.xs + 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.social_distance_rounded,
                    size: 16,
                    color: AppColors.error,
                  ),
                  AppSizes.gapH8,
                  Text(
                    'Distancia: $distanceText',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            
            AppSizes.gapV24,

            // Botón Intentar de Nuevo
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onRetry != null) onRetry();
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.surface,
                  size: 18,
                ),
                label: Text(
                  'Intentar de Nuevo',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ),
            ),
            
            AppSizes.gapV8,
            
            // Botón Cancelar
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                  side: const BorderSide(color: AppColors.primary),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}