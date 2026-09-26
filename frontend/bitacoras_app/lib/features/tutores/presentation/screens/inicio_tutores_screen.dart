import 'package:bitacoras_app/features/tutores/tutores.dart';

class InicioTutorAcademicoScreen extends StatefulWidget {
  final UsuarioModel user;
  final String? refreshToken;

  const InicioTutorAcademicoScreen({
    super.key,
    required this.user,
    this.refreshToken,
  });

  @override
  State<InicioTutorAcademicoScreen> createState() =>
      _InicioTutorAcademicoScreenState();
}

class _InicioTutorAcademicoScreenState
    extends State<InicioTutorAcademicoScreen> {
  EstadoVisitaTutorModel? _visit;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVisitState();
  }

  @override
  void didUpdateWidget(covariant InicioTutorAcademicoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _loadVisitState();
    }
  }

  Future<void> _loadVisitState() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final visit = await context.read<ITutorRepository>().getTodayVisitStatus();
      if (!mounted) return;
      setState(() {
        _visit = visit;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudo cargar el estado de la visita.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visit = _visit ?? const EstadoVisitaTutorModel();
    final modules = [
      TutorModule(
        title: 'Mis tutoriados',
        subtitle: 'Consultar estudiantes asignados',
        icon: Icons.groups_outlined,
        route: AppRoutes.estudiantesAsignados,
        accentColor: AppColores.secondary,
      ),
      TutorModule(
        title: 'Registrar entrada',
        subtitle: 'Iniciar visita académica',
        icon: Icons.login_outlined,
        route: AppRoutes.registrarVisitaTutor,
        accentColor: AppColores.info,
        enabled: visit.puedeRegistrarEntrada,
      ),
      TutorModule(
        title: 'Registrar actividades',
        subtitle: 'Guardar observaciones de la visita',
        icon: Icons.edit_note_outlined,
        route: AppRoutes.actividadesTutor,
        accentColor: AppColores.warning,
        enabled: visit.puedeRegistrarActividades,
      ),
      TutorModule(
        title: 'Registrar salida',
        subtitle: 'Finalizar visita académica',
        icon: Icons.logout_outlined,
        route: AppRoutes.registrarSalidaTutor,
        accentColor: AppColores.success,
        enabled: visit.puedeRegistrarSalida,
      ),
      TutorModule(
        title: 'Reportes',
        subtitle: 'Consultar y descargar visitas',
        icon: Icons.description_outlined,
        route: AppRoutes.reportes,
        accentColor: AppColores.primary,
      ),
    ];

    return LocationCheckerWrapper(
      child: Scaffold(
        backgroundColor: AppColores.background,
        appBar: InicioAppBar(user: widget.user, showDrawerButton: true),
        drawer: InicioDrawer(
          user: widget.user,
          sections: getOpcionesDrawerTutorAcademico(),
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColores.primary),
                )
              : _errorMessage != null
              ? TutorDashboardError(
                  message: _errorMessage!,
                  onRetry: _loadVisitState,
                )
              : RefreshIndicator(
                  color: AppColores.primary,
                  onRefresh: _loadVisitState,
                  child: TutorDashboardContent(
                    user: widget.user,
                    title: 'Panel del tutor académico',
                    description:
                        'Supervisa tus visitas y el avance de los estudiantes asignados.',
                    modules: modules,
                  ),
                ),
        ),
      ),
    );
  }
}

class InicioTutorEmpresarialScreen extends StatefulWidget {
  final UsuarioModel user;

  const InicioTutorEmpresarialScreen({
    super.key,
    required this.user,
  });

  @override
  State<InicioTutorEmpresarialScreen> createState() =>
      _InicioTutorEmpresarialScreenState();
}

class _InicioTutorEmpresarialScreenState
    extends State<InicioTutorEmpresarialScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  int _assignedStudents = 0;

  @override
  void initState() {
    super.initState();
    _loadAssignedStudents();
  }

  Future<void> _loadAssignedStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final students = await context.read<ITutorRepository>().getAssignedStudents(
        widget.user.id,
        isAcademic: false,
      );
      if (!mounted) return;
      setState(() {
        _assignedStudents = students.length;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudo cargar la información de los pasantes.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final modules = const [
      TutorModule(
        title: 'Pasantes asignados',
        subtitle: 'Consultar estudiantes de la empresa',
        icon: Icons.people_outline,
        route: AppRoutes.estudiantesAsignados,
        accentColor: AppColores.secondary,
      ),
      TutorModule(
        title: 'Mi perfil',
        subtitle: 'Información de la cuenta',
        icon: Icons.person_outline,
        route: AppRoutes.perfilUsuario,
        accentColor: AppColores.info,
      ),
    ];

    return LocationCheckerWrapper(
      child: Scaffold(
        backgroundColor: AppColores.background,
        appBar: InicioAppBar(user: widget.user, showDrawerButton: true),
        drawer: InicioDrawer(
          user: widget.user,
          sections: getOpcionesDrawerTutorEmpresarial(),
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColores.primary),
                )
              : _errorMessage != null
              ? TutorDashboardError(
                  message: _errorMessage!,
                  onRetry: _loadAssignedStudents,
                )
              : RefreshIndicator(
                  color: AppColores.primary,
                  onRefresh: _loadAssignedStudents,
                  child: TutorDashboardContent(
                    user: widget.user,
                    title: 'Panel del tutor empresarial',
                    description:
                        'Consulta el avance y seguimiento de tus pasantes asignados.',
                    summary: '$_assignedStudents pasante(s) asignado(s)',
                    modules: modules,
                  ),
                ),
        ),
      ),
    );
  }
}
