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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.assignedStudent;
    final student = item.student;

    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: student),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
          child: Column(
            children: [
              if (!widget.recordsOnly)
                EncabezadoSeguimientoEstudiante(item: item),
              if (!widget.recordsOnly) AppTamanos.gapV12,
              if (!widget.recordsOnly)
                Container(
                  decoration: BoxDecoration(
                    color: AppColores.surface,
                    borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                    border: Border.all(color: AppColores.outline),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColores.primary,
                    labelColor: AppColores.primary,
                    unselectedLabelColor: AppColores.textSecondary,
                    tabs: const [
                      Tab(text: 'Resumen'),
                      Tab(text: 'Registros'),
                    ],
                  ),
                ),
              if (!widget.recordsOnly) AppTamanos.gapV12,
              Expanded(
                child: widget.recordsOnly
                    ? ListaRegistrosSeguimiento(
                        isLoading: _isLoading,
                        errorMessage: _errorMessage,
                        logs: _logs,
                        onRefresh: _fetchLogs,
                        onToggleStatus: _toggleLogStatus,
                        onEdit: _editLog,
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          InformacionEstudianteSeguimiento(item: item),
                          ListaRegistrosSeguimiento(
                            isLoading: _isLoading,
                            errorMessage: _errorMessage,
                            logs: _logs,
                            onRefresh: _fetchLogs,
                            onToggleStatus: _toggleLogStatus,
                            onEdit: _editLog,
                          ),
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
