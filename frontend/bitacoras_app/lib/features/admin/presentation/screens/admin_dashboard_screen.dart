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
        widget.adminRepository.getCareers(),
        widget.adminRepository.getPeriods(),
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
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: widget.currentUser, showDrawerButton: true),
      drawer: InicioDrawer(
        user: widget.currentUser,
        sections: OpcionesDrawerFactory.getSectionsForRole(
          widget.currentUser.role,
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _errorMessage != null
            ? _DashboardError(message: _errorMessage!, onRetry: _loadDashboard)
            : RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _loadDashboard,
                child: _DashboardContent(
                  modules: _modules,
                  careers: _careers,
                  periods: _periods,
                ),
              ),
      ),
    );
  }

  List<_AdminModule> get _modules => [
    _AdminModule(
      'Usuarios',
      'Roles y cuentas institucionales',
      Icons.people_alt_outlined,
      AppRoutes.userManagement,
      AppColors.primary,
    ),
    _AdminModule(
      'Carreras',
      'Catálogo académico',
      Icons.school_outlined,
      AppRoutes.careerManagement,
      AppColors.secondary,
    ),
    _AdminModule(
      'Periodos lectivos',
      'Fechas y estados',
      Icons.calendar_month_outlined,
      AppRoutes.periodManagement,
      AppColors.warning,
    ),
    _AdminModule(
      'Carreras y periodos',
      'Habilita prácticas por periodo',
      Icons.tune_outlined,
      AppRoutes.careerPeriod,
      AppColors.info,
    ),
    _AdminModule(
      'Empresas',
      'Instituciones de práctica',
      Icons.business_outlined,
      AppRoutes.companyManagement,
      AppColors.success,
    ),
  ];
}

class _DashboardContent extends StatelessWidget {
  final List<_AdminModule> modules;
  final List<CarreraModel> careers;
  final List<PeriodoModel> periods;

  const _DashboardContent({
    required this.modules,
    required this.careers,
    required this.periods,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            _DashboardHero(
              activePeriods: periods.where((period) => period.isActive).length,
              activeCareers: careers.where((career) => career.isActive).length,
            ),
            AppSizes.gapV20,
            Text('Accesos de gestión', style: AppTextStyles.title),
            AppSizes.gapV12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: AppSizes.sm,
                mainAxisSpacing: AppSizes.sm,
                childAspectRatio: isWide ? 1.65 : 1.12,
              ),
              itemBuilder: (context, index) {
                final module = modules[index];
                return _ModuleCard(
                  module: module,
                  onTap: () => context.push(module.route),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _DashboardHero extends StatefulWidget {
  final int activePeriods;
  final int activeCareers;

  const _DashboardHero({
    required this.activePeriods,
    required this.activeCareers,
  });

  @override
  State<_DashboardHero> createState() => _DashboardHeroState();
}

class _DashboardHeroState extends State<_DashboardHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        return AdminGlowCard(
          accentColor: AppColors.primary,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.lg,
              AppSizes.lg,
              AppSizes.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const WavingHand(
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                AppSizes.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Panel de administración', style: AppTextStyles.heading),
                      AppSizes.gapV4,
                      Text(
                        'Gestiona catálogos y supervisa la operación académica desde un solo lugar.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.sizeOf(context).width >= 500)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _HeroStat(
                        value: widget.activeCareers.toString(),
                        label: 'carreras activas',
                      ),
                      AppSizes.gapV8,
                      _HeroStat(
                        value: widget.activePeriods.toString(),
                        label: 'periodos activos',
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.title.copyWith(color: AppColors.primary),
        ),
        AppSizes.gapH4,
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final _AdminModule module;
  final VoidCallback onTap;

  const _ModuleCard({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AdminGlowCard(
      accentColor: module.accentColor,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Icon(module.icon, color: module.accentColor, size: 28),
            AppSizes.gapH12,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold,
                  ),
                  AppSizes.gapV4,
                  Text(
                    module.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColors.error,
              size: 42,
            ),
            AppSizes.gapV12,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            AppSizes.gapV12,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accentColor;

  const _AdminModule(
    this.title,
    this.subtitle,
    this.icon,
    this.route,
    this.accentColor,
  );
}
