import 'package:bitacoras_app/features/tutores/tutores.dart';

class EstudiantesAsignadosScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final bool isAcademic;

  const EstudiantesAsignadosScreen({super.key, required this.currentUser, required this.isAcademic});

  @override
  State<EstudiantesAsignadosScreen> createState() => _EstudiantesAsignadosScreenState();
}

class _EstudiantesAsignadosScreenState extends State<EstudiantesAsignadosScreen> {
  List<EstudianteAsignadoModel> _assignedList = [];
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, Map<String, List<EstudianteAsignadoModel>>>
      get _studentsBySemester {
    final grouped = <String, Map<String, List<EstudianteAsignadoModel>>>{};
    for (final student in _assignedList) {
      final semester = student.student.semestreNombre?.trim().isNotEmpty == true
          ? student.student.semestreNombre!
          : 'Semestre sin asignar';
        const parallel = 'Pasantes asignados';
      grouped.putIfAbsent(semester, () => {});
      grouped[semester]!.putIfAbsent(parallel, () => []).add(student);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await context.read<ITutorRepository>().getAssignedStudents(
        widget.currentUser.id,
        isAcademic: widget.isAcademic,
      );
      if (!mounted) return;
      setState(() {
        _assignedList = data;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _assignedList = [];
        _errorMessage = 'No se pudo cargar la lista de estudiantes.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _errorMessage != null
            ? _AssignedStudentsError(message: _errorMessage!, onRetry: _loadData)
            : RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _loadData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSizes.md),
                  children: [
                    InstitutionalGlowCard(
                      accentColor: AppColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        child: Row(
                          children: [
                            const Icon(Icons.groups_outlined, color: AppColors.primary, size: 32),
                            AppSizes.gapH12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.isAcademic ? 'Mis tutoriados' : 'Pasantes en empresa',
                                    style: AppTextStyles.heading,
                                  ),
                                  AppSizes.gapV4,
                                  Text(
                                    '${_assignedList.length} estudiante(s) asignado(s)',
                                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSizes.gapV16,
                    if (_assignedList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(AppSizes.lg),
                        child: Center(child: Text('No hay estudiantes asignados.')),
                      )
                    else
                      ..._studentsBySemester.entries.map(
                        (semester) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.sm),
                          child: InstitutionalGlowCard(
                            accentColor: AppColors.primary,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                leading: const Icon(Icons.school_outlined, color: AppColors.primary),
                                title: Text(semester.key, style: AppTextStyles.bodyBold),
                                trailing: Text(
                                  '${semester.value.values.expand((items) => items).length}',
                                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                                ),
                                children: semester.value.entries
                                    .map(
                                      (parallel) => Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          AppSizes.md,
                                          0,
                                          AppSizes.md,
                                          AppSizes.sm,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(parallel.key, style: AppTextStyles.caption),
                                            AppSizes.gapV8,
                                            ...parallel.value.map(
                                              (item) => EstudianteTutorizadoCard(
                                                item: item,
                                                onRecordsTap: () => context.push(
                                                  widget.isAcademic
                                                      ? AppRoutes.academicTutorTracking
                                                      : AppRoutes.companyTutorTracking,
                                                  extra: item,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AssignedStudentsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AssignedStudentsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: AppColors.error, size: 42),
            AppSizes.gapV12,
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.body),
            AppSizes.gapV12,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}