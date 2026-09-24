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

  @override
  void initState() {
    super.initState();
    _cargarEmpresas();
  }

  Future<void> _cargarEmpresas() async {
    setState(() => _estaCargando = true);
    try {
      final empresas = await widget.adminRepository.getCompanies();
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

  Future<void> _abrirFormulario({EmpresaModel? empresa}) async {
    final resultado = await showModalBottomSheet<EmpresaModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EmpresaFormSheet(empresa: empresa),
    );
    if (resultado == null) return;

    try {
      if (empresa == null) {
        await widget.adminRepository.createCompany(resultado);
      } else {
        await widget.adminRepository.updateCompany(resultado);
      }
      await _cargarEmpresas();
      if (mounted) _mostrarExito('Empresa guardada correctamente.');
    } catch (error) {
      if (mounted) _mostrarError(_mensajeError(error));
    }
  }

  Future<void> _abrirDetalle(EmpresaModel empresa) async {
    final resultado = await Navigator.push<EmpresaModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EmpresaDetailScreen(
          usuarioActual: widget.currentUser,
          repositorio: widget.adminRepository,
          empresa: empresa,
        ),
      ),
    );
    if (resultado != null) await _cargarEmpresas();
  }

  String _mensajeError(Object error) {
    if (error is ApiException) return error.message;
    return 'No se pudo completar la operación.';
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final empresas = _empresasFiltradas;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
        showBackButton: true,
        onBackPressed: () => context.pop(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business_outlined, color: AppColors.surface),
        label: const Text('Nueva empresa'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmpresaListadoHeader(
                total: empresas.length,
                alBuscar: (valor) => setState(() => _consulta = valor),
                filtroEstado: _filtroEstado,
                alFiltrar: (valor) => setState(() => _filtroEstado = valor),
              ),
              AppSizes.gapV16,
              Expanded(
                child: _estaCargando
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : empresas.isEmpty
                    ? EmpresaListadoVacio(filtroEstado: _filtroEstado)
                    : RefreshIndicator(
                        onRefresh: _cargarEmpresas,
                        child: ListView.separated(
                          itemCount: empresas.length,
                          separatorBuilder: (context, index) => AppSizes.gapV8,
                          itemBuilder: (context, index) {
                            final empresa = empresas[index];
                            return EmpresaTile(
                              empresa: empresa,
                              alAbrir: () => _abrirDetalle(empresa),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
