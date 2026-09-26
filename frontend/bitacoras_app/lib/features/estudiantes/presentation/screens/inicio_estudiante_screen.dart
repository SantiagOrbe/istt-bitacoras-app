import 'dart:async';

import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class InicioEstudianteScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const InicioEstudianteScreen({super.key, required this.currentUser});

  @override
  State<InicioEstudianteScreen> createState() => _InicioEstudianteScreenState();
}

class _InicioEstudianteScreenState extends State<InicioEstudianteScreen>
    with WidgetsBindingObserver {
  bool _estaCargando = true;
  String? _mensajeError;
  RegistroAsistenciaModel? _todayRecord;
  bool _practiceComplete = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDashboard();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _loadDashboard(showLoading: false),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadDashboard(showLoading: false);
    }
  }

  Future<void> _loadDashboard({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _estaCargando = true;
        _mensajeError = null;
      });
    }

    try {
      final repository = context.read<IAsistenciaRepositorio>();
      final results = await Future.wait([
        repository.obtenerRegistroHoy(),
        repository.obtenerProgresoPracticasEstudiante(),
      ]);

      if (!mounted) return;
      final progress = results[1] as Map<String, dynamic>;
      setState(() {
        _todayRecord = results[0] as RegistroAsistenciaModel?;
        _practiceComplete = (progress['completo'] ?? false) == true;
        _estaCargando = false;
        _mensajeError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _estaCargando = false;
        _mensajeError = 'No se pudo cargar el panel del estudiante.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAcademicAssignment =
        (widget.currentUser.semestreId ?? '').trim().isNotEmpty &&
        (widget.currentUser.paraleloId ?? '').trim().isNotEmpty;
    final hasCompanyAssignment =
        (widget.currentUser.companyId ?? '').trim().isNotEmpty;
    final hasRecord = _todayRecord != null;
    final hasActivities = _todayRecord?.hasActivities ?? false;
    final isClosed = _todayRecord?.exitTime != null;
    final canAccessPracticas =
        widget.currentUser.puedeRegistrarPracticas &&
        hasAcademicAssignment &&
        hasCompanyAssignment;
    final canEnter = canAccessPracticas && !hasRecord && !_estaCargando && !_practiceComplete;
    final canActivity = canAccessPracticas &&
        hasRecord && !hasActivities && !isClosed && !_estaCargando && !_practiceComplete;
    final canExit = canAccessPracticas &&
        hasRecord && hasActivities && !isClosed && !_estaCargando && !_practiceComplete;

    return LocationCheckerWrapper(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) await SystemNavigator.pop();
        },
        child: Scaffold(
          backgroundColor: AppColores.background,
          appBar: InicioAppBar(user: widget.currentUser, showDrawerButton: true),
          drawer: InicioDrawer(
            user: widget.currentUser,
            sections: getOpcionesDrawerEstudiante(
              canEnter: canEnter,
              canActivities: canActivity,
              canExit: canExit,
              canAccessPracticas: canAccessPracticas,
            ),
          ),
          body: SafeArea(
            child: _estaCargando
                ? const Center(
                    child: CircularProgressIndicator(color: AppColores.primary),
                  )
                : _mensajeError != null
                ? EstudianteDashboardError(
                    message: _mensajeError!,
                    onRetry: _loadDashboard,
                  )
                : RefreshIndicator(
                    color: AppColores.primary,
                    onRefresh: _loadDashboard,
                    child: EstudianteDashboardContenido(
                      currentUser: widget.currentUser,
                      canEnter: canEnter,
                      canActivity: canActivity,
                      canExit: canExit,
                      canAccessPracticas: canAccessPracticas,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

