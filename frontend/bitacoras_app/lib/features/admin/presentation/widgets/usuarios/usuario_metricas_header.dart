import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

class UsuarioMetricasHeader extends StatelessWidget {
  final int totalUsers;
  final int totalStudents;
  final int totalTutors;
  final int totalActive;

  const UsuarioMetricasHeader({
    super.key,
    this.totalUsers = 0,
    this.totalStudents = 0,
    this.totalTutors = 0,
    this.totalActive = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildMetricChip('Total', '$totalUsers', AppColors.primary),
          _buildMetricChip('Estudiantes', '$totalStudents', AppColors.textSecondary),
          _buildMetricChip('Tutores', '$totalTutors', AppColors.secondary),
          _buildMetricChip('Activos', '$totalActive', AppColors.success),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, String count, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(right: AppSizes.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
          AppSizes.gapH8,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              count,
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}