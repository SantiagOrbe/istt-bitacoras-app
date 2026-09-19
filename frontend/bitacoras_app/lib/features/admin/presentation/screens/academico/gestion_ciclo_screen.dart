import 'package:bitacoras_app/app/apps.dart';

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
      builder: (context) => CicloFormSheet(
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
          backgroundColor: success ? AppColors.success : AppColors.error,
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
          backgroundColor: success ? AppColors.success : AppColors.error,
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
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openCycleForm(),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nuevo semestre',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.surface),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizes.gapV12,
                  Text(
                    'Semestres de la carrera',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Carrera: ${_controller.careerName}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV12,
                  CarreraSearchBar(
                    onChanged: _controller.setSearchQuery,
                    hintText: 'Buscar curso...',
                  ),
                  AppSizes.gapV12,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'Todos',
                          selected: _controller.statusFilter == 'all',
                          onSelected: (_) => _controller.setStatusFilter('all'),
                        ),
                        _FilterChip(
                          label: 'Activos',
                          selected: _controller.statusFilter == 'active',
                          onSelected: (_) => _controller.setStatusFilter('active'),
                        ),
                        _FilterChip(
                          label: 'Inactivos',
                          selected: _controller.statusFilter == 'inactive',
                          onSelected: (_) => _controller.setStatusFilter('inactive'),
                        ),
                      ],
                    ),
                  ),
                  AppSizes.gapV12,
                  Text(
                    '${_controller.filteredCycles.length} semestres registrados',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV12,
                  Expanded(
                    child: _controller.filteredCycles.isEmpty
                        ? AdminEmptyState(
                            title: _controller.searchQuery.isNotEmpty
                                ? 'No se encontraron semestres'
                                : 'Aún no hay semestres registrados',
                            subtitle: _controller.searchQuery.isNotEmpty
                                ? 'Prueba con otro criterio de búsqueda.'
                                : 'Crea el primer semestre para comenzar.',
                            icon: Icons.school_rounded,
                            accentColor: AppColors.primary,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.filteredCycles.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final cycle = _controller.filteredCycles[index];
                              return CicloCard(
                                cycle: cycle,
                                onTap: () {
                                  if (widget.careerId != null) {
                                    context.push(
                                      AppRoutes.nestedParallelManagement
                                          .replaceFirst(
                                            ':carreraId',
                                            widget.careerId!,
                                          )
                                          .replaceFirst(
                                            ':semestreId',
                                            cycle.id,
                                          ),
                                    );
                                  } else {
                                    _openCycleForm(cycle: cycle);
                                  }
                                },
                                onEdit: () => _openCycleForm(cycle: cycle),
                                onToggleStatus: () => _toggleStatus(cycle),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        backgroundColor: AppColors.surface,
        labelStyle: AppTextStyles.body.copyWith(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outline,
        ),
      ),
    );
  }
}
