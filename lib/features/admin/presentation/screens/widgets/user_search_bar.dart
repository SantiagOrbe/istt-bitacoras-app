import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const UserSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o cédula...',
        hintStyle:
            AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.secondary,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}