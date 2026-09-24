import 'package:bitacoras_app/features/admin/admin.dart';

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
        child: BotonPrisma(
          texto: 'Guardar configuración',
          icono: Icons.save_rounded,
          alPresionar: onSave,
          anchoCompleto: true,
        ),
      ),
    );
  }
}
