import 'package:bitacoras_app/features/admin/admin.dart';

class GestionParaleloScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;
  final String? careerId;
  final String? semesterId;

  const GestionParaleloScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
    this.careerId,
    this.semesterId,
  });

  @override
  State<GestionParaleloScreen> createState() => _GestionParaleloScreenState();
}

typedef ParalelosManagementScreen = GestionParaleloScreen;

class _GestionParaleloScreenState extends State<GestionParaleloScreen> {
  late final GestionParaleloController _controller;
  late final GestionParaleloActions _actions;

  @override
  void initState() {
    super.initState();
    _controller = GestionParaleloController(repository: widget.adminRepository);
    _actions = GestionParaleloActions(
      context: context,
      controller: _controller,
      repository: widget.adminRepository,
      semesterId: widget.semesterId,
    );
    _controller.loadData(
      careerId: widget.careerId,
      semesterId: widget.semesterId,
    );
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
            onPressed: () => _actions.openParallelForm(),
            backgroundColor: AppColores.primary,
            icon: const Icon(Icons.add_rounded, color: AppColores.surface),
            label: Text(
              'Nuevo paralelo',
              style: AppEstiloTexto.bodyBold.copyWith(
                color: AppColores.surface,
              ),
            ),
          ),
          body: SafeArea(
            child: GestionParaleloBody(
              isLoading: _controller.isLoading,
              searchQuery: _controller.searchQuery,
              statusFilter: _controller.statusFilter,
              cycles: _controller.cycles,
              parallels: _controller.filteredParallels,
              subtitle: widget.semesterId == null
                  ? 'Organización de jornadas y estudiantes'
                  : 'Semestre: ${_controller.getCycleName(widget.semesterId!)}',
              count: _controller.filteredParallels.length,
              onSearchChanged: _controller.setSearchQuery,
              onStatusChanged: _controller.setStatusFilter,
              onParallelTap: _actions.openParallelForm,
              onToggleStatus: _actions.toggleStatus,
              onAssignStudents: _actions.assignStudents,
              onRemoveStudents: _actions.removeAllStudents,
            ),
          ),
        );
      },
    );
  }
}
