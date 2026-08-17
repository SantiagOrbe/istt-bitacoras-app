import 'package:bitacoras_app/core/widgets/buttons/custom_button.dart';
import 'package:bitacoras_app/shared/exports.dart';

class SaveBottomBar extends StatelessWidget {
  final VoidCallback onSave;

  const SaveBottomBar({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: CustomButton(
          text: 'Guardar Configuración',
          icon: Icons.save_rounded,
          onPressed: onSave,
          isFullWidth: false,
        ),
      ),
    );
  }
}