import 'package:bitacoras_app/shared/exports.dart';

class AsistenciaActionButtons extends StatelessWidget {
  final bool isEntry;
  final bool isLoading;
  final bool enabled;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AsistenciaActionButtons({
    super.key,
    required this.isEntry,
    required this.isLoading,
    this.enabled = true,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = isEntry ? 'Confirmar Entrada' : 'Confirmar Salida';
    final buttonIcon = isEntry ? Icons.login_outlined : Icons.logout_outlined;
    final effectiveEnabled = enabled && !isLoading;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: effectiveEnabled ? AppColors.primary : AppColors.disabled,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            onPressed: effectiveEnabled ? onConfirm : null,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.surface,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(buttonIcon),
            label: Text(
              isLoading ? 'Procesando...' : buttonText,
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.surface),
            ),
          ),
        ),
        AppSizes.gapV12,
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            onPressed: onCancel,
            child: Text(
              'Cancelar',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
