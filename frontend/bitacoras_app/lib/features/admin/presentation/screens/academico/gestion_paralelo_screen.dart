import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/academico/estudiante_paralelo_card.dart';

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
          .map((student) => student['id'] as int)
          .toSet();
      if (!mounted) return;
      final result = await showDialog<Set<int>>(
        context: context,
        builder: (context) => _StudentAssignmentDialog(
          students: students,
          selected: selected,
          parallelName: parallel.name,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizes.gapV12,
                  Text(
                    'Gestión de Paralelos',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (widget.semesterId != null)
                    Text(
                      'Semestre: ${_controller.getCycleName(widget.semesterId!)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  AppSizes.gapV12,
                  CarreraSearchBar(
                    onChanged: _controller.setSearchQuery,
                    hintText: 'Buscar paralelo...',
                  ),
                  AppSizes.gapV12,
                  DropdownButtonFormField<String?>(
                    initialValue: _controller.selectedCycleId,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por semestre',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Todos los semestres'),
                      ),
                      ..._controller.cycles.map(
                        (cycle) => DropdownMenuItem<String?>(
                          value: cycle.id,
                          child: Text('${cycle.name} (Nivel ${cycle.level})'),
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
                    '${_controller.filteredParallels.length} paralelos registrados',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV12,
                  Expanded(
                    child: _controller.filteredParallels.isEmpty
                        ? AdminEmptyState(
                            title: _controller.searchQuery.isNotEmpty
                                ? 'No se encontraron paralelos'
                                : 'Aún no hay paralelos registrados',
                            subtitle: _controller.searchQuery.isNotEmpty
                                ? 'Prueba con otro criterio de búsqueda.'
                                : 'Crea el primer paralelo para comenzar.',
                            icon: Icons.groups_rounded,
                            accentColor: AppColors.secondary,
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
                                onAssignStudents: () => _assignStudents(parallel),
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

class _StudentAssignmentDialog extends StatefulWidget {
  final List<Map<String, dynamic>> students;
  final Set<int> selected;
  final String parallelName;

  const _StudentAssignmentDialog({
    required this.students,
    required this.selected,
    required this.parallelName,
  });

  @override
  State<_StudentAssignmentDialog> createState() =>
      _StudentAssignmentDialogState();
}

class _StudentAssignmentDialogState extends State<_StudentAssignmentDialog> {
  final _searchController = TextEditingController();
  late final Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.selected};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final visibleStudents = widget.students.where((student) {
      final text = '${student['nombre'] ?? ''} ${student['email'] ?? ''} '
          '${student['cedula'] ?? ''}'.toLowerCase();
      return query.isEmpty || text.contains(query);
    }).toList();
      final assignedStudents = visibleStudents
        .where((student) => student['seleccionado'] == true)
        .toList();
      final availableStudents = visibleStudents
        .where(
          (student) =>
            student['seleccionado'] != true && student['bloqueado'] != true,
        )
        .toList();
      final blockedStudents = visibleStudents
        .where((student) => student['bloqueado'] == true)
        .toList();

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: Text('Asignar estudiantes al paralelo ${widget.parallelName}'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.52,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Buscar estudiante',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            AppSizes.gapV12,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_selected.length} seleccionados de ${widget.students.length}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            AppSizes.gapV8,
            Expanded(
              child: visibleStudents.isEmpty
                  ? const Center(child: Text('No hay estudiantes disponibles.'))
                  : ListView(
                      children: [
                        _sectionHeader(
                          'Ya pertenecen a este paralelo',
                          assignedStudents.length,
                          Icons.check_circle_outline,
                        ),
                        if (assignedStudents.isEmpty)
                          const _AssignmentMessage(
                            text: 'Todavía no hay estudiantes asignados.',
                          )
                        else
                          ...assignedStudents.map(
                            (student) => _studentCard(student, blocked: false),
                          ),
                        _sectionHeader(
                          'Estudiantes disponibles',
                          availableStudents.length,
                          Icons.person_add_alt_1_outlined,
                        ),
                        if (availableStudents.isEmpty)
                          const _AssignmentMessage(
                            text: 'No hay estudiantes disponibles para asignar.',
                          )
                        else
                          ...availableStudents.map(
                            (student) => _studentCard(student, blocked: false),
                          ),
                        if (blockedStudents.isNotEmpty) ...[
                          _sectionHeader(
                            'Ya pertenecen a otro paralelo',
                            blockedStudents.length,
                            Icons.lock_outline,
                          ),
                          ...blockedStudents.map(
                            (student) => _studentCard(student, blocked: true),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, _selected),
          icon: const Icon(Icons.check),
          label: const Text('Guardar asignación'),
        ),
      ],
    );
  }

  Widget _studentCard(
    Map<String, dynamic> student, {
    required bool blocked,
  }) {
    final id = student['id'] as int;
    return EstudianteParaleloCard(
      student: student,
      selected: _selected.contains(id),
      blocked: blocked,
      onChanged: (value) => setState(() {
        value == true ? _selected.add(id) : _selected.remove(id);
      }),
    );
  }

  Widget _sectionHeader(String title, int count, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.sm, bottom: AppSizes.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          AppSizes.gapH8,
          Expanded(
            child: Text(
              '$title ($count)',
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentMessage extends StatelessWidget {
  final String text;

  const _AssignmentMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
