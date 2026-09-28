import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraPeriodoScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;
  final String? initialPeriodId;

  const CarreraPeriodoScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
    this.initialPeriodId,
  });

  @override
  State<CarreraPeriodoScreen> createState() => _CarreraPeriodoScreenState();
}

class _CarreraPeriodoScreenState extends State<CarreraPeriodoScreen> {
  late final CarreraPeriodoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarreraPeriodoController(repository: widget.adminRepository);
    _controller.loadData(initialPeriodId: widget.initialPeriodId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveConfiguration();
    if (mounted && (success || _controller.errorMessage != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Configuración guardada exitosamente.'
                : _controller.errorMessage!,
            style: AppEstiloTexto.body.copyWith(color: AppColores.surface),
          ),
          backgroundColor: success ? AppColores.success : AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColores.background,
          appBar: InicioAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          body: _controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColores.primary),
                )
              : _controller.errorMessage != null
              ? Center(child: Text(_controller.errorMessage!))
              : CarreraPeriodoBody(
                  periods: _controller.periods,
                  careers: _controller.careers,
                    selectableSemestersByCareer:
                      _controller.selectableSemestersByCareer,
                  selectedPeriodId: _controller.selectedPeriodId,
                  configs: _controller.configs,
                  getConfigKey: _controller.getConfigKey,
                  onPeriodChanged: _controller.selectPeriod,
                  onToggleSemester: _controller.toggleSemester,
                ),
          bottomNavigationBar: _controller.isLoading
              ? null
              : BarraGuardarAdmin(onSave: _handleSave),
        );
      },
    );
  }
}
