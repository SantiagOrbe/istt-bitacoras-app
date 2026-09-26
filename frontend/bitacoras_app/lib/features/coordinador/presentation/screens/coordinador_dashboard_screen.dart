import 'package:bitacoras_app/features/coordinador/coordinador.dart';


class CoordinadorDashboardScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final ICoordinadorRepository repository;

  const CoordinadorDashboardScreen({
    super.key,
    required this.currentUser,
    required this.repository,
  });

  @override
  State<CoordinadorDashboardScreen> createState() =>
      _CoordinadorDashboardScreenState();
}

class _CoordinadorDashboardScreenState
    extends State<CoordinadorDashboardScreen> {
  bool _estaCargando = true;
  String? _mensajeError;
  int _cantidadCarreras = 0;
  int _cantidadEstudiantes = 0;
  int _cantidadTutores = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _estaCargando = true;
      _mensajeError = null;
    });

    try {
      final results = await Future.wait([
        widget.repository.obtenerCarreras(),
        widget.repository.obtenerDatosCarrera(),
      ]);
      final careerData = results[1] as CoordinadorDatosModel;

      if (!mounted) return;
      setState(() {
        _cantidadCarreras =
            (results[0] as List<CoordinadorCarreraModel>).length;
        _cantidadEstudiantes = careerData.estudiantes.length;
        _cantidadTutores = careerData.tutores.length;
        _estaCargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _estaCargando = false;
        _mensajeError = 'No se pudo cargar el panel del coordinador.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: widget.currentUser, showDrawerButton: true),
      drawer: InicioDrawer(
        user: widget.currentUser,
        sections: OpcionesDrawerFactory.getSectionsForRole(
          widget.currentUser.role,
        ),
      ),
      body: SafeArea(
        child: _estaCargando
            ? const Center(
                child: CircularProgressIndicator(color: AppColores.primary),
              )
            : _mensajeError != null
            ? CoordinadorDashboardError(
                message: _mensajeError!,
                onRetry: _loadDashboard,
              )
            : RefreshIndicator(
                color: AppColores.primary,
                onRefresh: _loadDashboard,
                child: CoordinadorDashboardContenido(
                  currentUser: widget.currentUser,
                  cantidadCarreras: _cantidadCarreras,
                  cantidadEstudiantes: _cantidadEstudiantes,
                  cantidadTutores: _cantidadTutores,
                ),
              ),
      ),
    );
  }
}
