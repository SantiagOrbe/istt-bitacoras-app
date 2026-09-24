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

  @override
  void initState() {
    super.initState();
    _controller = GestionParaleloController(repository: widget.adminRepository);
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

  Future<void> _openParallelForm({ParaleloModel? parallel}) async {
    if (_controller.cycles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero crea al menos un semestre.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await showModalBottomSheet<ParaleloFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ParaleloFormSheet(
        cycles: _controller.cycles,
        parallel: parallel,
        fixedCycleId: widget.semesterId,
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    final success = await _controller.saveParallel(
      parallelId: parallel?.id,
      cycleId: result.cycleId,
      name: result.name,
      jornada: result.jornada,
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

  Future<void> _toggleStatus(ParaleloModel parallel) async {
    final success = await _controller.toggleStatus(parallel);

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

  Future<void> _assignStudents(ParaleloModel parallel) async {
    try {
      final students = await widget.adminRepository.getParallelStudents(
        parallel.id,
      );
      final selected = students
          .where((student) => student['seleccionado'] == true)
          .map((student) => int.tryParse(student['id']?.toString() ?? ''))
          .whereType<int>()
          .toSet();
      if (!mounted) return;
      final result = await showDialog<Set<int>>(
        context: context,
        builder: (context) => AsignacionEstudiantesDialog(
          estudiantes: students,
          seleccionados: selected,
          nombreParalelo: parallel.name,
        ),
      );
      if (result == null || !mounted) return;
      await widget.adminRepository.assignParallelStudents(
        parallel.id,
        result.toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiantes asignados correctamente.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _removeAllStudents(ParaleloModel parallel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirar estudiantes'),
        content: Text(
          '¿Quieres retirar todos los estudiantes del paralelo ${parallel.name}? '
          'Luego podrás asignarlos a otro semestre.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Retirar todos'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await widget.adminRepository.removeParallelStudents(parallel.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estudiantes retirados correctamente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
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
            onPressed: () => _openParallelForm(),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nuevo paralelo',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.surface),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.sm,
                AppSizes.md,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.md,
                      AppSizes.md,
                      AppSizes.md,
                      AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.outline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.secondary,
                                    AppColors.warning,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                              ),
                              child: const Icon(
                                Icons.groups_rounded,
                                color: AppColors.surface,
                              ),
                            ),
                            AppSizes.gapH12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gestión de paralelos',
                                    style: AppTextStyles.title,
                                  ),
                                  Text(
                                    widget.semesterId == null
                                        ? 'Organización de jornadas y estudiantes'
                                        : 'Semestre: ${_controller.getCycleName(widget.semesterId!)}',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${_controller.filteredParallels.length}',
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.primary,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        AppSizes.gapV16,
                        CarreraSearchBar(
                          onChanged: _controller.setSearchQuery,
                          hintText: 'Buscar paralelo o jornada...',
                        ),
                        AppSizes.gapV12,
                        DropdownButtonFormField<String?>(
                          initialValue: _controller.selectedCycleId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Filtrar por semestre',
                            prefixIcon: Icon(Icons.layers_outlined),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Todos los semestres'),
                            ),
                            ..._controller.cycles.map(
                              (cycle) => DropdownMenuItem<String?>(
                                value: cycle.id,
                                child: Text(
                                  '${cycle.name} (Nivel ${cycle.level})',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: _controller.setSelectedCycle,
                        ),
                        AppSizes.gapV12,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(
                                label: 'Todos',
                                selected: _controller.statusFilter == 'all',
                                onSelected: (_) =>
                                    _controller.setStatusFilter('all'),
                              ),
                              _FilterChip(
                                label: 'Activos',
                                selected: _controller.statusFilter == 'active',
                                onSelected: (_) =>
                                    _controller.setStatusFilter('active'),
                              ),
                              _FilterChip(
                                label: 'Inactivos',
                                selected:
                                    _controller.statusFilter == 'inactive',
                                onSelected: (_) =>
                                    _controller.setStatusFilter('inactive'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSizes.gapV16,
                  Expanded(
                    child: _controller.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : _controller.filteredParallels.isEmpty
                        ? AdminEmptyState(
                            title: _controller.searchQuery.isNotEmpty
                                ? 'No se encontraron paralelos'
                                : 'Aún no hay paralelos registrados',
                            subtitle: _controller.searchQuery.isNotEmpty
                                ? 'Prueba con otro criterio de búsqueda.'
                                : 'Crea el primer paralelo para comenzar.',
                            icon: Icons.groups_rounded,
                            accentColor: AppColors.primary,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.filteredParallels.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final parallel =
                                  _controller.filteredParallels[index];
                              return ParaleloCard(
                                parallel: parallel,
                                cycleName: _controller.getCycleName(
                                  parallel.cycleId,
                                ),
                                onTap: () =>
                                    _openParallelForm(parallel: parallel),
                                onToggleStatus: () => _toggleStatus(parallel),
                                onAssignStudents: () =>
                                    _assignStudents(parallel),
                                onRemoveStudents: () =>
                                    _removeAllStudents(parallel),
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
