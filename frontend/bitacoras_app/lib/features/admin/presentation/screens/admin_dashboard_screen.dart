import 'package:bitacoras_app/features/admin/admin.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const AdminDashboardScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<CarreraModel> _careers = const [];
  List<PeriodoModel> _periods = const [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        widget.adminRepository.obtenerCarreras(),
        widget.adminRepository.obtenerPeriodos(),
      ]);

      if (!mounted) return;
      setState(() {
        _careers = results[0] as List<CarreraModel>;
        _periods = results[1] as List<PeriodoModel>;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudo cargar el resumen administrativo.';
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
        child: CuerpoPanelAdmin(
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          modules: _modules,
          careers: _careers,
          periods: _periods,
          onRefresh: _loadDashboard,
          onRetry: _loadDashboard,
        ),
      ),
    );
  }

  List<ModuloPanelAdmin> get _modules => [
    ModuloPanelAdmin(
      title: 'Usuarios',
      subtitle: 'Roles y cuentas institucionales',
      icon: Icons.people_alt_outlined,
      route: AppRoutes.gestionUsuarios,
      accentColor: AppColores.primary,
    ),
    ModuloPanelAdmin(
      title: 'Carreras',
      subtitle: 'Catálogo académico',
      icon: Icons.school_outlined,
      route: AppRoutes.gestionCarreras,
      accentColor: AppColores.secondary,
    ),
    ModuloPanelAdmin(
      title: 'Periodos lectivos',
      subtitle: 'Fechas y estados',
      icon: Icons.calendar_month_outlined,
      route: AppRoutes.gestionPeriodos,
      accentColor: AppColores.warning,
    ),
    ModuloPanelAdmin(
      title: 'Carreras y periodos',
      subtitle: 'Habilita prácticas por periodo',
      icon: Icons.tune_outlined,
      route: AppRoutes.periodoAcademico,
      accentColor: AppColores.info,
    ),
    ModuloPanelAdmin(
      title: 'Empresas',
      subtitle: 'Instituciones de práctica',
      icon: Icons.business_outlined,
      route: AppRoutes.gestionEmpresasAdmin,
      accentColor: AppColores.success,
    ),
  ];
}
