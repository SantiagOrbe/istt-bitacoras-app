import 'package:bitacoras_app/features/admin/admin.dart';

class GestionCicloScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;
  final String? careerId;

  const GestionCicloScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
    this.careerId,
  });

  @override
  State<GestionCicloScreen> createState() => _GestionCicloScreenState();
}

typedef SemestresManagementScreen = GestionCicloScreen;

class _GestionCicloScreenState extends State<GestionCicloScreen> {
  late final GestionCicloController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GestionCicloController(repository: widget.adminRepository);
    _controller.loadCycles(careerId: widget.careerId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCycleForm({CicloModel? cycle}) async {
    final result = await showModalBottomSheet<CicloFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HojaFormularioCiclo(
        cycle: cycle,
        careers: widget.careerId == null
            ? _controller.careers
            : _controller.careers
                  .where((career) => career.id == widget.careerId)
                  .toList(),
        fixedCareerId: widget.careerId,
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    final success = await _controller.saveCycle(
      cycleId: cycle?.id,
      careerId: result.careerId,
      name: result.name,
      level: result.level,
      hoursPracticas: result.hoursPracticas,
      isActive: result.isActive,
    );

    if (!mounted) {
      return;
    }

    final message = _controller.successMessage ?? _controller.errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColores.success : AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleStatus(CicloModel cycle) async {
    final success = await _controller.toggleStatus(cycle);

    if (!mounted) {
      return;
    }

    final message = _controller.successMessage ?? _controller.errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColores.success : AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
            onPressed: () => _openCycleForm(),
            backgroundColor: AppColores.primary,
            icon: const Icon(Icons.add_rounded, color: AppColores.surface),
            label: Text(
              'Nuevo semestre',
              style: AppEstiloTexto.bodyBold.copyWith(
                color: AppColores.surface,
              ),
            ),
          ),
          body: SafeArea(
            child: GestionCicloBody(
              isLoading: _controller.isLoading,
              careerName: _controller.careerName,
              searchQuery: _controller.searchQuery,
              statusFilter: _controller.statusFilter,
              isAscendingOrder: _controller.isAscendingSort,
              cycles: _controller.filteredCycles,
              onSearchChanged: _controller.setSearchQuery,
              onStatusChanged: _controller.setStatusFilter,
              onSortOrderChanged: _controller.toggleSortOrder,
              onCycleTap: (cycle) {
                final careerId = widget.careerId?.isNotEmpty == true
                    ? widget.careerId!
                    : cycle.careerId;
                if (careerId.isNotEmpty) {
                  context.push(
                    AppRoutes.gestionParalelosAnidados
                        .replaceFirst(':carreraId', careerId)
                        .replaceFirst(':semestreId', cycle.id),
                  );
                  return;
                }

                _openCycleForm(cycle: cycle);
              },
              onEdit: _openCycleForm,
              onToggleStatus: _toggleStatus,
            ),
          ),
        );
      },
    );
  }
}
