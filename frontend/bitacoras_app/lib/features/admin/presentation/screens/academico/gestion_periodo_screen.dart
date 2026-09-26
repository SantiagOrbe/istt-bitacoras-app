import 'package:bitacoras_app/features/admin/admin.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/academico/boton_configurar_carreras_periodo.dart';

class GestionPeriodoScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const GestionPeriodoScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<GestionPeriodoScreen> createState() => _GestionPeriodoScreenState();
}

class _GestionPeriodoScreenState extends State<GestionPeriodoScreen> {
  late final GestionPeriodoController _controller;
  late final GestionPeriodoActions _actions;

  @override
  void initState() {
    super.initState();
    _controller = GestionPeriodoController(repository: widget.adminRepository);
    _actions = GestionPeriodoActions(context: context, controller: _controller);
    _controller.loadPeriods();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final activePeriods = _controller.periods
          .where((period) => period.isActive)
          .toList();
        final activePeriod = activePeriods.isEmpty
          ? null
          : activePeriods.first;

        return Scaffold(
          backgroundColor: AppColores.background,
          appBar: InicioAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _actions.openPeriodForm(),
            backgroundColor: AppColores.primary,
            icon: const Icon(Icons.add_rounded, color: AppColores.surface),
            label: Text(
              'Nuevo período',
              style: AppEstiloTexto.bodyBold.copyWith(
                color: AppColores.surface,
              ),
            ),
          ),
          body: SafeArea(
            child: GestionPeriodoBody(
              isLoading: _controller.isLoading,
              searchQuery: _controller.searchQuery,
              periods: _controller.filteredPeriods,
              accionPeriodoActivo: activePeriod == null
                  ? null
                  : BotonConfigurarCarrerasPeriodo(
                      periodo: activePeriod,
                      onPressed: () {
                        final destino = Uri(
                          path: AppRoutes.periodoAcademico,
                          queryParameters: {'periodoId': activePeriod.id},
                        );
                        context.push(destino.toString());
                      },
                    ),
              onSearchChanged: _controller.setSearchQuery,
              onOpenPeriodForm: _actions.openPeriodForm,
              onToggleStatus: _actions.toggleStatus,
            ),
          ),
        );
      },
    );
  }
}
