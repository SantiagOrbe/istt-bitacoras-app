import 'package:bitacoras_app/features/tutores/tutores.dart';


class DetalleSeguimientoEstudianteScreen extends StatefulWidget {
  final EstudianteAsignadoModel assignedStudent;
  final bool isAcademic;
  final bool recordsOnly;

  const DetalleSeguimientoEstudianteScreen({
    super.key,
    required this.assignedStudent,
    this.isAcademic = true,
    this.recordsOnly = false,
  });

  @override
  State<DetalleSeguimientoEstudianteScreen> createState() =>
      _DetalleSeguimientoEstudianteScreenState();
}

class _DetalleSeguimientoEstudianteScreenState
    extends State<DetalleSeguimientoEstudianteScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<RegistroPracticaModel> _logs = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchLogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final logs = await context.read<ITutorRepository>().getStudentLogs(
        widget.assignedStudent.student.id,
        isAcademic: widget.isAcademic,
      );
      if (!mounted) return;
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _logs = const [];
        _isLoading = false;
        _errorMessage = 'No se pudieron cargar los registros.';
      });
    }
  }

  Future<void> _toggleLogStatus(RegistroPracticaModel log) async {
    try {
      final updated = await context.read<ITutorRepository>().updateLog(
        logId: log.id,
        isActive: !log.isActive,
      );
      if (!mounted) return;
      final index = _logs.indexWhere((item) => item.id == log.id);
      if (index != -1) {
        setState(() => _logs = [..._logs]..[index] = updated);
      }
    } catch (_) {
      _showMessage('No se pudo cambiar el estado del registro.');
    }
  }

  Future<void> _editLog(RegistroPracticaModel log) async {
    final controller = TextEditingController(text: log.activityDescription);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar registro'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.isEmpty || !mounted) return;

    try {
      final updated = await context.read<ITutorRepository>().updateLog(
        logId: log.id,
        activityDescription: value,
      );
      if (!mounted) return;
      final index = _logs.indexWhere((item) => item.id == log.id);
      if (index != -1) {
        setState(() => _logs = [..._logs]..[index] = updated);
      }
    } catch (_) {
      _showMessage('No se pudo guardar el registro.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.assignedStudent;
    final student = item.student;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: student),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              if (!widget.recordsOnly) InstitutionalGlowCard(
                accentColor: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: AppTextStyles.heading),
                      AppSizes.gapV4,
                      Text(
                        student.company ?? 'Empresa no registrada',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSizes.gapV12,
                      Row(
                        children: [
                          Expanded(
                            child: _StatPill(
                              label: 'Horas',
                              value:
                                  '${item.totalHoursCompletedLabel} / ${item.totalHoursRequiredLabel} h',
                            ),
                          ),
                          AppSizes.gapH12,
                          Expanded(
                            child: _StatPill(
                              label: 'Estado',
                              value: item.status,
                            ),
                          ),
                        ],
                      ),
                      AppSizes.gapV12,
                      LinearProgressIndicator(
                        value: item.progressPercentage,
                        minHeight: 9,
                        backgroundColor: AppColors.divider,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              if (!widget.recordsOnly) AppSizes.gapV12,
              if (!widget.recordsOnly) Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.outline),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  tabs: const [
                    Tab(text: 'Resumen'),
                    Tab(text: 'Registros'),
                  ],
                ),
              ),
              if (!widget.recordsOnly) AppSizes.gapV12,
              Expanded(
                child: widget.recordsOnly
                    ? _buildLogs()
                    : TabBarView(
                        controller: _tabController,
                        children: [_buildSummary(item), _buildLogs()],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(EstudianteAsignadoModel item) {
    final student = item.student;
    return ListView(
      children: [
        _InfoTile(
          icon: Icons.business_outlined,
          title: 'Empresa',
          value: student.company ?? 'Sin empresa',
        ),
        _InfoTile(
          icon: Icons.badge_outlined,
          title: 'Cédula',
          value: student.cedula ?? 'Sin registro',
        ),
        _InfoTile(
          icon: Icons.email_outlined,
          title: 'Correo electrónico',
          value: student.email,
        ),
        _InfoTile(
          icon: Icons.phone_outlined,
          title: 'Teléfono',
          value: student.phone ?? 'Sin registro',
        ),
        _InfoTile(
          icon: Icons.school_outlined,
          title: 'Carrera',
          value: student.careerName ?? 'Sin carrera',
        ),
        _InfoTile(
          icon: Icons.class_outlined,
          title: 'Semestre',
          value: student.semestreNombre ?? 'Sin semestre',
        ),
        _InfoTile(
          icon: Icons.person_outline,
          title: 'Tutor empresarial',
          value:
              '${item.companyTutorName} ${item.companyTutorPhone.isNotEmpty ? '(${item.companyTutorPhone})' : ''}',
        ),
        _InfoTile(
          icon: Icons.edit_note_outlined,
          title: 'Última actividad',
          value: item.lastActivityDescription ?? 'Sin actividad registrada',
        ),
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          title: 'Última fecha',
          value: item.lastActivityDate ?? 'Sin registro',
        ),
      ],
    );
  }

  Widget _buildLogs() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_errorMessage != null) {
      return Center(
        child: OutlinedButton.icon(
          onPressed: _fetchLogs,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(_errorMessage!),
        ),
      );
    }
    if (_logs.isEmpty) {
      return Center(
        child: Text('Sin registros de práctica.', style: AppTextStyles.body),
      );
    }
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: InstitutionalGlowCard(
            accentColor: log.isActive
                ? AppColors.primary
                : AppColors.textSecondary,
            child: ListTile(
              title: Text(
                '${log.date} - ${log.entryTimeLabel}',
                style: AppTextStyles.bodyBold,
              ),
              subtitle: Text(
                log.activityDescription,
                style: AppTextStyles.caption,
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') _editLog(log);
                  if (value == 'toggle') _toggleLogStatus(log);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(log.isActive ? 'Desactivar' : 'Activar'),
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

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.infoSoft,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          AppSizes.gapV4,
          Text(value, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: InstitutionalGlowCard(
        accentColor: AppColors.secondary,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              AppSizes.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.caption),
                    AppSizes.gapV4,
                    Text(value, style: AppTextStyles.body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
