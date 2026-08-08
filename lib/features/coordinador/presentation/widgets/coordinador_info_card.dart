import 'package:flutter/material.dart';
import '../../../../config/constants/app_colors.dart';

class CoordinadorInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? extraInfo;
  final IconData icon;

  const CoordinadorInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.extraInfo,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.successSoft,
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          extraInfo != null ? '$subtitle\n$extraInfo' : subtitle,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        isThreeLine: extraInfo != null,
      ),
    );
  }
}