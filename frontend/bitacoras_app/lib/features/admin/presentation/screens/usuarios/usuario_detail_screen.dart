import 'package:bitacoras_app/features/admin/admin.dart';

class UsuarioDetailScreen extends StatefulWidget {
  final UsuarioModel user;
  final IAdminRepository adminRepository;

  const UsuarioDetailScreen({
    super.key,
    required this.user,
    required this.adminRepository,
  });

  @override
  State<UsuarioDetailScreen> createState() => _UsuarioDetailScreenState();
}

class _UsuarioDetailScreenState extends State<UsuarioDetailScreen> {
  late final UsuarioDetailController _controller;
  late final AccionesDetalleUsuario _actions;

  @override
  void initState() {
    super.initState();
    _controller = UsuarioDetailController(
      repository: widget.adminRepository,
      initialUser: widget.user,
    );
    _actions = AccionesDetalleUsuario(
      context: context,
      controller: _controller,
    );
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (!mounted) return;

    if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage!),
          backgroundColor: AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (_controller.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.successMessage!),
          backgroundColor: AppColores.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: InicioAppBar(
            user: _controller.user,
            showBackButton: true,
            onBackPressed: () => context.pop(_controller.user),
          ),
          backgroundColor: AppColores.background,
          body: _controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColores.primary),
                )
              : CuerpoDetalleUsuario(
                  user: _controller.user,
                  isLoading: _controller.isLoading,
                  controller: _controller,
                  onSave: _controller.saveChanges,
                  onToggleStatus: _actions.confirmToggleStatus,
                ),
        );
      },
    );
  }
}
