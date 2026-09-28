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
