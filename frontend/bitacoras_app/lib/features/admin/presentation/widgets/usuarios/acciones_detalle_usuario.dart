import 'package:bitacoras_app/features/admin/admin.dart';

class AccionesDetalleUsuario {
  final BuildContext context;
  final UsuarioDetailController controller;

  const AccionesDetalleUsuario({
    required this.context,
    required this.controller,
  });

  Future<void> confirmToggleStatus() async {
    final isActive = controller.user.isActive;
    final action = isActive ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColores.surface,
        title: Text(
          '${isActive ? 'Desactivar' : 'Activar'} Usuario',
          style: const TextStyle(color: AppColores.textPrimary),
        ),
        content: Text(
          '¿Está seguro de $action a ${controller.user.name}?',
          style: const TextStyle(color: AppColores.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColores.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? AppColores.error : AppColores.success,
              foregroundColor: AppColores.surface,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(isActive ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await controller.toggleUserStatus();
    }
  }
}
