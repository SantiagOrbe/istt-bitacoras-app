import 'package:bitacoras_app/features/tutores/tutores.dart';

class EstudiantesAsignadosScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final bool isAcademic;

  const EstudiantesAsignadosScreen({
    super.key,
    required this.currentUser,
    required this.isAcademic,
  });

  @override
  State<EstudiantesAsignadosScreen> createState() =>
      _EstudiantesAsignadosScreenState();
}

class _EstudiantesAsignadosScreenState extends State<EstudiantesAsignadosScreen> {
  List<EstudianteAsignadoModel> _assignedList = [];
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, Map<String, List<EstudianteAsignadoModel>>> get _studentsBySemester {
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
      setState(() => _assignedList = data);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _assignedList = [];
        _errorMessage = 'No se pudo cargar la lista de estudiantes.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColores.primary),
              )
            : _errorMessage != null
                ? ErrorEstudiantesAsignados(
                    message: _errorMessage!,
                    onRetry: _loadData,
                  )
                : RefreshIndicator(
                    color: AppColores.primary,
                    onRefresh: _loadData,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppTamanos.md),
                      children: [
                        EncabezadoEstudiantesAsignados(
                          titulo: widget.isAcademic
                              ? 'Mis tutoriados'
                              : 'Pasantes en empresa',
                          cantidad: _assignedList.length,
                        ),
                        AppTamanos.gapV16,
                        if (_assignedList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(AppTamanos.lg),
                            child: Center(
                              child: Text('No hay estudiantes asignados.'),
                            ),
                          )
                        else
                          ..._studentsBySemester.entries.map(
                            (semester) => GrupoEstudiantesAsignados(
                              semestre: semester.key,
                              grupos: semester.value,
                              isAcademic: widget.isAcademic,
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}