import 'package:bitacoras_app/features/admin/admin.dart';

class UsuarioDetailActionButtons extends StatelessWidget {
  final bool isEditing;
  final bool isActive;
  final VoidCallback onSave;
  final VoidCallback onToggleStatus;

  const UsuarioDetailActionButtons({
    super.key,
    required this.isEditing,
    required this.isActive,
    required this.onSave,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.save_outlined),
        label: const Text(
          'Guardar Cambios',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: onSave,
      );
    }

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: isActive ? AppColors.error : AppColors.success,
        side: BorderSide(color: isActive ? AppColors.error : AppColors.success),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(isActive ? Icons.block_outlined : Icons.check_circle_outline),
      label: Text(
        isActive ? 'Desactivar Usuario' : 'Activar Usuario',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onPressed: onToggleStatus,
    );
  }
}
