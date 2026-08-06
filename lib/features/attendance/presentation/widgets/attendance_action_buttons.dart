import 'package:bitacoras_app/shared/exports.dart';

class AttendanceActionButtons extends StatelessWidget {
  final bool isEntry;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AttendanceActionButtons({
    super.key,
    required this.isEntry,
    required this.isLoading,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = isEntry ? 'Confirmar Entrada' : 'Confirmar Salida';
    final buttonIcon = isEntry ? Icons.login_outlined : Icons.logout_outlined;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            onPressed: isLoading ? null : onConfirm,
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