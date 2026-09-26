import 'package:bitacoras_app/features/admin/admin.dart';

class CuerpoDetalleUsuario extends StatelessWidget {
  final UsuarioModel user;
  final bool isLoading;
  final UsuarioDetailController controller;
  final VoidCallback onSave;
  final VoidCallback onToggleStatus;

  const CuerpoDetalleUsuario({
    super.key,
    required this.user,
    required this.isLoading,
    required this.controller,
    required this.onSave,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            CabeceraDetalleUsuario(
              user: user,
              onToggleStatus: onToggleStatus,
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            TarjetaInfoUsuario(controller: controller),
            const SizedBox(height: 24),
            BotonesAccionDetalleUsuario(
              isEditing: controller.isEditing,
              isActive: user.isActive,
              onSave: onSave,
              onToggleStatus: onToggleStatus,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
