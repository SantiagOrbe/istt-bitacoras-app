import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraPeriodoScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const CarreraPeriodoScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
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
    _controller.loadData();
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
            style: AppTextStyles.body.copyWith(color: AppColors.surface),
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
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
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          body: _controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : _controller.errorMessage != null
              ? Center(child: Text(_controller.errorMessage!))
              : CarreraPeriodoBody(
                  periods: _controller.periods,
                  careers: _controller.careers,
                  selectedPeriodId: _controller.selectedPeriodId,
                  configs: _controller.configs,
                  getConfigKey: _controller.getConfigKey,
                  onPeriodChanged: _controller.selectPeriod,
                  onToggleSemester: _controller.toggleSemester,
                ),
          bottomNavigationBar: _controller.isLoading
              ? null
              : SaveBottomBar(onSave: _handleSave),
        );
      },
    );
  }
}
