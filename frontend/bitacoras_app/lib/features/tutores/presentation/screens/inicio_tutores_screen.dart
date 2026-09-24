import 'package:bitacoras_app/features/tutores/tutores.dart';


class InicioTutorAcademicoScreen extends StatefulWidget {
  final UsuarioModel user;
  final String? refreshToken;

  const InicioTutorAcademicoScreen({
    super.key,
    required this.user,
    this.refreshToken,
  });

  @override
  State<InicioTutorAcademicoScreen> createState() =>
      _InicioTutorAcademicoScreenState();
}

class _InicioTutorAcademicoScreenState
    extends State<InicioTutorAcademicoScreen> {
  EstadoVisitaTutorModel? _visit;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVisitState();
  }

  @override
  void didUpdateWidget(covariant InicioTutorAcademicoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _loadVisitState();
    }
  }

  Future<void> _loadVisitState() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final visit = await context.read<ITutorRepository>().getTodayVisitStatus();
      if (!mounted) return;
      setState(() {
        _visit = visit;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudo cargar el estado de la visita.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visit = _visit ?? const EstadoVisitaTutorModel();
    return LocationCheckerWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: InicioAppBar(user: widget.user, showDrawerButton: true),
        drawer: InicioDrawer(
          user: widget.user,
          sections: getOpcionesDrawerTutorAcademico(),
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : _errorMessage != null
              ? _TutorDashboardError(
                  message: _errorMessage!,
                  onRetry: _loadVisitState,
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _loadVisitState,
                  child: _TutorDashboardContent(
                    user: widget.user,
                    title: 'Panel del tutor académico',
                    description:
                        'Supervisa tus visitas y el avance de los estudiantes asignados.',
                    modules: [
                      _TutorModule(
                        title: 'Mis tutoriados',
                        subtitle: 'Consultar estudiantes asignados',
                        icon: Icons.groups_outlined,
                        route: AppRoutes.assignedStudents,
                        accentColor: AppColors.secondary,
                      ),
                      _TutorModule(
                        title: 'Registrar entrada',
                        subtitle: 'Iniciar visita académica',
                        icon: Icons.login_outlined,
                        route: AppRoutes.academicTutorRegisterVisit,
                        accentColor: AppColors.info,
                        enabled: visit.puedeRegistrarEntrada,
                      ),
                      _TutorModule(
                        title: 'Registrar actividades',
                        subtitle: 'Guardar observaciones de la visita',
                        icon: Icons.edit_note_outlined,
                        route: AppRoutes.academicTutorActivities,
                        accentColor: AppColors.warning,
                        enabled: visit.puedeRegistrarActividades,
                      ),
                      _TutorModule(
                        title: 'Registrar salida',
                        subtitle: 'Finalizar visita académica',
                        icon: Icons.logout_outlined,
                        route: AppRoutes.academicTutorRegisterDeparture,
                        accentColor: AppColors.success,
                        enabled: visit.puedeRegistrarSalida,
                      ),
                      _TutorModule(
                        title: 'Reportes',
                        subtitle: 'Consultar y descargar visitas',
                        icon: Icons.description_outlined,
                        route: AppRoutes.reports,
                        accentColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class InicioTutorEmpresarialScreen extends StatefulWidget {
  final UsuarioModel user;

  const InicioTutorEmpresarialScreen({
    super.key,
    required this.user,
  });

  @override
  State<InicioTutorEmpresarialScreen> createState() =>
      _InicioTutorEmpresarialScreenState();
}

class _InicioTutorEmpresarialScreenState
    extends State<InicioTutorEmpresarialScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  int _assignedStudents = 0;

  @override
  void initState() {
    super.initState();
    _loadAssignedStudents();
  }

  Future<void> _loadAssignedStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final students = await context.read<ITutorRepository>().getAssignedStudents(
        widget.user.id,
        isAcademic: false,
      );
      if (!mounted) return;
      setState(() {
        _assignedStudents = students.length;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudo cargar la información de los pasantes.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocationCheckerWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: InicioAppBar(user: widget.user, showDrawerButton: true),
        drawer: InicioDrawer(
          user: widget.user,
          sections: getOpcionesDrawerTutorEmpresarial(),
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : _errorMessage != null
              ? _TutorDashboardError(
                  message: _errorMessage!,
                  onRetry: _loadAssignedStudents,
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _loadAssignedStudents,
                  child: _TutorDashboardContent(
                    user: widget.user,
                    title: 'Panel del tutor empresarial',
                    description:
                        'Consulta el avance y seguimiento de tus pasantes asignados.',
                    summary: '$_assignedStudents pasante(s) asignado(s)',
                    modules: const [
                      _TutorModule(
                        title: 'Pasantes asignados',
                        subtitle: 'Consultar estudiantes de la empresa',
                        icon: Icons.people_outline,
                        route: AppRoutes.assignedStudents,
                        accentColor: AppColors.secondary,
                      ),
                      _TutorModule(
                        title: 'Mi perfil',
                        subtitle: 'Información de la cuenta',
                        icon: Icons.person_outline,
                        route: AppRoutes.perfil,
                        accentColor: AppColors.info,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _TutorDashboardContent extends StatelessWidget {
  final UsuarioModel user;
  final String title;
  final String description;
  final String? summary;
  final List<_TutorModule> modules;

  const _TutorDashboardContent({
    required this.user,
    required this.title,
    required this.description,
    required this.modules,
    this.summary,
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
            _TutorDashboardHero(
              userName: user.name,
              title: title,
              description: description,
            ),
            if (summary != null) ...[
              AppSizes.gapV12,
              Text(summary!, style: AppTextStyles.bodyBold),
            ],
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
                childAspectRatio: isWide ? 1.55 : 1.0,
              ),
              itemBuilder: (context, index) {
                final module = modules[index];
                return _TutorModuleCard(
                  module: module,
                  onTap: module.enabled ? () => context.push(module.route) : null,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _TutorDashboardHero extends StatelessWidget {
  final String userName;
  final String title;
  final String description;

  const _TutorDashboardHero({
    required this.userName,
    required this.title,
    required this.description,
  });

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
                  Text(title, style: AppTextStyles.heading),
                  AppSizes.gapV4,
                  Text(
                    'Hola, $userName. $description',
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

class _TutorModuleCard extends StatelessWidget {
  final _TutorModule module;
  final VoidCallback? onTap;

  const _TutorModuleCard({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = module.enabled ? module.accentColor : AppColors.textSecondary;
    return InstitutionalGlowCard(
      accentColor: color,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Icon(module.icon, color: color, size: 28),
            AppSizes.gapH12,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold.copyWith(color: color),
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
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}

class _TutorDashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TutorDashboardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: AppColors.error, size: 42),
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

class _TutorModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accentColor;
  final bool enabled;

  const _TutorModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.accentColor,
    this.enabled = true,
  });
}