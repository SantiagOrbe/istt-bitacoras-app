import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class RegistroActividadActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onAddMore;
  final bool enabled;

  const RegistroActividadActionButtons({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.onAddMore,
    this.enabled = true,
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
          onPressed: enabled ? onSave : null,
        ),
        AppSizes.gapV16,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.10),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: InkWell(
            onTap: onAddMore,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  AppSizes.gapH8,
                  Text(
                    'Agregar otra actividad',
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
