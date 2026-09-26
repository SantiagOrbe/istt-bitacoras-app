import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class InicioResponsablePracticasScreen extends StatefulWidget {
  const InicioResponsablePracticasScreen({super.key});

  @override
  State<InicioResponsablePracticasScreen> createState() =>
      _InicioResponsablePracticasScreenState();
}

class _InicioResponsablePracticasScreenState
    extends State<InicioResponsablePracticasScreen> {
  bool _estaCargando = true;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarPanel();
  }

  Future<void> _cargarPanel() async {
    setState(() {
      _estaCargando = true;
      _mensajeError = null;
    });

    try {
      final repository = context.read<IResponsablePracticasRepository>();
      await Future.wait([
        repository.getCompanies(),
        repository.getStudentAssignments(),
        repository.getAssignmentOptions(),
      ]);

      if (!mounted) return;
      setState(() => _estaCargando = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _estaCargando = false;
        _mensajeError = 'No se pudo cargar el panel del responsable.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthSession>().currentUser!;

    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: currentUser, showDrawerButton: true),
      drawer: InicioDrawer(
        user: currentUser,
        sections: OpcionesDrawerFactory.getSectionsForRole(currentUser.role),
      ),
      body: SafeArea(
        child: _estaCargando
            ? const Center(
                child: CircularProgressIndicator(color: AppColores.primary),
              )
            : _mensajeError != null
                ? ErrorPanelResponsablePracticas(
                    message: _mensajeError!,
                    onRetry: _cargarPanel,
                  )
                : RefreshIndicator(
                    color: AppColores.primary,
                    onRefresh: _cargarPanel,
                    child: PanelResponsablePracticasContenido(
                      currentUser: currentUser,
                    ),
                  ),
      ),
    );
  }
}
