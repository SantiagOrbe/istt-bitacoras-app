import 'package:bitacoras_app/features/admin/admin.dart';

class GestionEmpresaScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const GestionEmpresaScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<GestionEmpresaScreen> createState() => _GestionEmpresaScreenState();
}

class _GestionEmpresaScreenState extends State<GestionEmpresaScreen> {
  List<EmpresaModel> _empresas = [];
  bool _estaCargando = true;
  bool? _filtroEstado;
  String _consulta = '';
  late final GestionEmpresaActions _actions;

  @override
  void initState() {
    super.initState();
    _actions = GestionEmpresaActions(
      context: context,
      currentUser: widget.currentUser,
      repository: widget.adminRepository,
      reloadCompanies: _cargarEmpresas,
    );
    _cargarEmpresas();
  }

  Future<void> _cargarEmpresas() async {
    setState(() => _estaCargando = true);
    try {
      final empresas = await widget.adminRepository.obtenerEmpresas();
      if (!mounted) return;
      setState(() {
        _empresas = empresas;
        _estaCargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _estaCargando = false);
      _mostrarError(_mensajeError(error));
    }
  }

  List<EmpresaModel> get _empresasFiltradas {
    final consulta = _consulta.trim().toLowerCase();
    return _empresas.where((empresa) {
      final coincideEstado = _filtroEstado == null
          ? true
          : empresa.isActive == (_filtroEstado == false);
      final coincideConsulta =
          consulta.isEmpty ||
          empresa.name.toLowerCase().contains(consulta) ||
          empresa.email.toLowerCase().contains(consulta);
      return coincideEstado && coincideConsulta;
    }).toList();
  }

  String _mensajeError(Object error) {
    if (error is ApiException) return error.message;
    return 'No se pudo completar la operación.';
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: AppColores.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final empresas = _empresasFiltradas;

    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
        showBackButton: true,
        onBackPressed: () => context.pop(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _actions.openForm(),
        backgroundColor: AppColores.primary,
        icon: const Icon(
          Icons.add_business_outlined,
          color: AppColores.surface,
        ),
        label: const Text('Nueva empresa'),
      ),
      body: SafeArea(
        child: GestionEmpresaBody(
          isLoading: _estaCargando,
          empresas: empresas,
          searchQuery: _consulta,
          filterState: _filtroEstado,
          onRefresh: _cargarEmpresas,
          onSearchChanged: (valor) => setState(() => _consulta = valor),
          onFilterChanged: (valor) => setState(() => _filtroEstado = valor),
          onOpenDetail: _actions.openDetail,
          onOpenForm: _actions.openForm,
        ),
      ),
    );
  }
}
