import 'package:bitacoras_app/features/admin/admin.dart';

class GestionEmpresaActions {
  final BuildContext context;
  final UsuarioModel currentUser;
  final IAdminRepository repository;
  final Future<void> Function() reloadCompanies;

  const GestionEmpresaActions({
    required this.context,
    required this.currentUser,
    required this.repository,
    required this.reloadCompanies,
  });

  Future<void> openForm({EmpresaModel? empresa}) async {
    final result = await showModalBottomSheet<EmpresaModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HojaFormularioEmpresa(empresa: empresa),
    );
    if (result == null || !context.mounted) return;

    try {
      if (empresa == null) {
        await repository.crearEmpresa(result);
      } else {
        await repository.actualizarEmpresa(result);
      }
      await reloadCompanies();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Empresa guardada correctamente.'),
            backgroundColor: AppColores.success,
          ),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_mensajeError(error)),
          backgroundColor: AppColores.error,
        ),
      );
    }
  }

  Future<void> openDetail(EmpresaModel empresa) async {
    final result = await Navigator.push<EmpresaModel>(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaDetalleEmpresa(
          usuarioActual: currentUser,
          repositorio: repository,
          empresa: empresa,
        ),
      ),
    );

    if (result != null) {
      await reloadCompanies();
    }
  }

  String _mensajeError(Object error) {
    if (error is ApiException) return error.message;
    return 'No se pudo completar la operación.';
  }
}
