import 'package:flutter/material.dart';
import 'package:bitacoras_app/core/widgets/buttons/custom_button.dart';
import 'package:bitacoras_app/shared/exports.dart';

class RegistroActividadActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onAddMore;

  const RegistroActividadActionButtons({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.onAddMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          isFullWidth: true,
          text: 'Guardar Actividad',
          icon: Icons.save_rounded,
          isLoading: isLoading,
          onPressed: onSave,
        ),
        AppSizes.gapV16,
        Center(
          child: TextButton.icon(
            onPressed: onAddMore,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            label: Text(
              'Agregar otra actividad',
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
