import 'dart:async';

import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class InicioEstudianteScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const InicioEstudianteScreen({super.key, required this.currentUser});

  @override
  State<InicioEstudianteScreen> createState() => _InicioEstudianteScreenState();
}

class _InicioEstudianteScreenState extends State<InicioEstudianteScreen>
    with WidgetsBindingObserver {
  bool _estaCargando = true;
  String? _mensajeError;
  RegistroAsistenciaModel? _todayRecord;
  bool _practiceComplete = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDashboard();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _loadDashboard(showLoading: false),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadDashboard(showLoading: false);
    }
  }

  Future<void> _loadDashboard({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _estaCargando = true;
        _mensajeError = null;
      });
    }

    try {
      final repository = context.read<IAsistenciaRepository>();
      final results = await Future.wait([
        repository.getTodayRecord(),
        repository.getStudentPracticeProgress(),
      ]);

      if (!mounted) return;
      final progress = results[1] as Map<String, dynamic>;
      setState(() {
        _todayRecord = results[0] as RegistroAsistenciaModel?;
        _practiceComplete = (progress['completo'] ?? false) == true;
        _estaCargando = false;
        _mensajeError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _estaCargando = false;
        _mensajeError = 'No se pudo cargar el panel del estudiante.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasRecord = _todayRecord != null;
    final hasActivities = _todayRecord?.hasActivities ?? false;
    final isClosed = _todayRecord?.exitTime != null;
    final canEnter = !hasRecord && !_estaCargando && !_practiceComplete;
    final canActivity =
        hasRecord && !hasActivities && !isClosed && !_estaCargando && !_practiceComplete;
    final canExit =
        hasRecord && hasActivities && !isClosed && !_estaCargando && !_practiceComplete;

    return LocationCheckerWrapper(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) await SystemNavigator.pop();
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(user: widget.currentUser, showDrawerButton: true),
          drawer: InicioDrawer(
            user: widget.currentUser,
            sections: getOpcionesDrawerEstudiante(
              canEnter: canEnter,
              canActivities: canActivity,
              canExit: canExit,
            ),
          ),
          body: SafeArea(
            child: _estaCargando
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _mensajeError != null
                ? _DashboardError(
                    message: _mensajeError!,
                    onRetry: _loadDashboard,
                  )
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _loadDashboard,
                    child: _DashboardContent(
                      currentUser: widget.currentUser,
                      canEnter: canEnter,
                      canActivity: canActivity,
                      canExit: canExit,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final UsuarioModel currentUser;
  final bool canEnter;
  final bool canActivity;
  final bool canExit;

  const _DashboardContent({
    required this.currentUser,
    required this.canEnter,
    required this.canActivity,
    required this.canExit,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            _DashboardHero(userName: currentUser.name),
            AppSizes.gapV20,
            Text('Accesos de práctica', style: AppTextStyles.title),
            AppSizes.gapV12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _modules.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.sm,
                mainAxisSpacing: AppSizes.sm,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final module = _modules[index];
                return _ModuleCard(
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

  List<_StudentModule> get _modules => [
    _StudentModule(
      'Registrar entrada',
      'Marcar inicio de jornada',
      Icons.login_outlined,
      AppRoutes.attendance,
      AppColors.secondary,
      canEnter,
    ),
    _StudentModule(
      'Registrar actividades',
      'Describir las actividades de hoy',
      Icons.edit_note_outlined,
      AppRoutes.registerActivity,
      AppColors.info,
      canActivity,
    ),
    _StudentModule(
      'Registrar salida',
      'Marcar fin de jornada',
      Icons.logout_outlined,
      AppRoutes.registerExitAttendance,
      AppColors.warning,
      canExit,
    ),
    const _StudentModule(
      'Reportes',
      'Descargar informe de prácticas',
      Icons.description_outlined,
      AppRoutes.reports,
      AppColors.success,
      true,
    ),
  ];
}

class _DashboardHero extends StatelessWidget {
  final String userName;

  const _DashboardHero({required this.userName});

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
                  Text('Panel del estudiante', style: AppTextStyles.heading),
                  AppSizes.gapV4,
                  Text(
                    'Hola, $userName. Registra y consulta tu jornada de prácticas.',
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
  final _StudentModule module;
  final VoidCallback? onTap;

  const _ModuleCard({required this.module, required this.onTap});

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
                    maxLines: 1,
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: color,
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

class _StudentModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accentColor;
  final bool enabled;

  const _StudentModule(
    this.title,
    this.subtitle,
    this.icon,
    this.route,
    this.accentColor,
    this.enabled,
  );
}