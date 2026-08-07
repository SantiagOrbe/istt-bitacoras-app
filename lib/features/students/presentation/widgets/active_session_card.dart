import 'package:bitacoras_app/features/admin/admin.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';
import 'package:bitacoras_app/features/students/domain/models/practice_record_model.dart';

class ActiveSessionCard extends StatelessWidget {
  final PracticeRecordModel record;
  final VoidCallback onExitPressed;

  const ActiveSessionCard({
    super.key,
    required this.record,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos el amarillo institucional (warning) para dar contexto de "En Proceso"
    final warningAccent = AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: warningAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: warningAccent.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Cabecera: Fecha y Estado de la sesión
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.textPrimary,
                    size: 18,
                  ),
                  AppSizes.gapH8,
                  Text(
                    record.date,
                    style: AppTextStyles.bodyBold,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: warningAccent.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 14,
                      color: AppColors.textPrimary,
                    ),
                    AppSizes.gapH4,
                    Text(
                      record.status,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: Divider(color: AppColors.divider),
          ),

          // Horarios de Entrada y Salida
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entrada',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV4,
                  Text(
                    record.entryTime,
                    style: AppTextStyles.bodyBold,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Salida',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV4,
                  Text(
                    record.exitTime ?? 'Esperando marcación...',
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: record.exitTime == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                      color: record.exitTime == null
                          ? AppTextStyles.caption.color
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          AppSizes.gapV16,

          // Botón de Marcación de Salida
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              text: 'Marcar Salida',
              icon: Icons.location_on_outlined,
              isFullWidth: false,
              onPressed: onExitPressed,
            ),
          ),
        ],
      ),
    );
  }
}