import 'package:bitacoras_app/features/admin/admin.dart';

class GestionUsuarioScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const GestionUsuarioScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<GestionUsuarioScreen> createState() => _GestionUsuarioScreenState();
}

class _GestionUsuarioScreenState extends State<GestionUsuarioScreen> {
  late final GestionUsuarioController _controller;
  late final GestionUsuarioActions _actions;

  @override
  void initState() {
    super.initState();
    _controller = GestionUsuarioController(repository: widget.adminRepository);
    _actions = GestionUsuarioActions(
      context: context,
      repository: widget.adminRepository,
      controller: _controller,
    );
    _controller.fetchUsers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColores.background,
          appBar: InicioAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _actions.openUserForm,
            backgroundColor: AppColores.primary,
            icon: const Icon(Icons.add_rounded, color: AppColores.surface),
            label: Text(
              'Nuevo Usuario',
              style: AppEstiloTexto.bodyBold.copyWith(
                color: AppColores.surface,
              ),
            ),
          ),
          body: SafeArea(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GestionUsuarioBody(
                    users: _controller.filteredUsers,
                    totalUsers: _controller.totalUsers,
                    totalStudents: _controller.totalStudents,
                    totalTutors: _controller.totalTutors,
                    totalActive: _controller.totalActive,
                    onUserTap: (user) => context
                        .push(AppRoutes.detalleUsuario, extra: user)
                        .then((updatedUser) {
                          if (updatedUser is UsuarioModel) {
                            _controller.updateUserLocally(updatedUser);
                          }
                        }),
                    onSearchChanged: _controller.setSearchQuery,
                    roleFilter: _controller.roleFilter,
                    activeFilter: _controller.activeFilter,
                    onRoleChanged: _controller.setRoleFilter,
                    onActiveChanged: _controller.setActiveFilter,
                  ),
          ),
        );
      },
    );
  }
}
