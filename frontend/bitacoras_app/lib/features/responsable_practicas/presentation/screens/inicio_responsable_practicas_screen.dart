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
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
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
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: currentUser, showDrawerButton: true),
      drawer: InicioDrawer(
        user: currentUser,
        sections: OpcionesDrawerFactory.getSectionsForRole(currentUser.role),
      ),
      body: SafeArea(
        child: _estaCargando
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _mensajeError != null
            ? _DashboardError(message: _mensajeError!, onRetry: _loadDashboard)
            : RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _loadDashboard,
                child: _DashboardContent(currentUser: currentUser),
              ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final UsuarioModel currentUser;

  const _DashboardContent({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            _DashboardHero(userName: currentUser.name),
            AppSizes.gapV20,
            Text('Accesos de gestión', style: AppTextStyles.title),
            AppSizes.gapV12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _modules.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: AppSizes.sm,
                mainAxisSpacing: AppSizes.sm,
                childAspectRatio: isWide ? 1.65 : 1.12,
              ),
              itemBuilder: (context, index) {
                final module = _modules[index];
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

  List<_ResponsableModule> get _modules => [
    _ResponsableModule(
      'Gestión de Empresas',
      'Catálogo de instituciones y convenios',
      Icons.business_outlined,
      AppRoutes.responsablePracticasCompanies,
      AppColors.secondary,
    ),
    _ResponsableModule(
      'Asignación de Estudiantes',
      'Vincular estudiantes y tutores',
      Icons.person_add_alt_1_outlined,
      AppRoutes.responsablePracticasAssignStudents,
      AppColors.info,
    ),
  ];
}

class _DashboardHero extends StatefulWidget {
  final String userName;

  const _DashboardHero({required this.userName});

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
    return InstitutionalGlowCard(
      accentColor: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const WavingHand(color: AppColors.primary, size: 28),
            ),
            AppSizes.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panel del responsable de prácticas',
                    style: AppTextStyles.heading,
                  ),
                  AppSizes.gapV4,
                  Text(
                    'Hola, ${widget.userName}. Gestiona empresas y asignaciones de prácticas.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final _ResponsableModule module;
  final VoidCallback onTap;

  const _ModuleCard({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
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
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.body),
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

class _ResponsableModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accentColor;

  const _ResponsableModule(
    this.title,
    this.subtitle,
    this.icon,
    this.route,
    this.accentColor,
  );
}