import 'package:bitacoras_app/features/admin/admin.dart';

class GestionUsuarioActions {
  final BuildContext context;
  final IAdminRepository repository;
  final GestionUsuarioController controller;

  const GestionUsuarioActions({
    required this.context,
    required this.repository,
    required this.controller,
  });

  Future<void> openUserForm() async {
    final user = await showModalBottomSheet<UsuarioModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HojaFormularioUsuario(repository: repository),
    );
    if (user == null || !context.mounted) return;

    try {
      await repository.crearUsuario(user);
      await controller.fetchUsers();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado correctamente.')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      final message = error is ApiException
          ? error.message
          : 'No se pudo crear el usuario.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColores.error),
      );
    }
  }
}
