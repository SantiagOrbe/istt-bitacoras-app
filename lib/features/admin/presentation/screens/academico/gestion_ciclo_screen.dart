import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/ciclo_model.dart';
import 'package:bitacoras_app/features/admin/presentation/controllers/academico/gestion_ciclo_controller.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/admin_empty_state.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_search_bar.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/academico/ciclo_card.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/academico/ciclo_form_sheet.dart';

class GestionCicloScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const GestionCicloScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<GestionCicloScreen> createState() => _GestionCicloScreenState();
}

class _GestionCicloScreenState extends State<GestionCicloScreen> {
  late final GestionCicloController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GestionCicloController(repository: widget.adminRepository);
    _controller.loadCycles();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCycleForm({CicloModel? cycle}) async {
    final result = await showModalBottomSheet<CicloFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CicloFormSheet(cycle: cycle),
    );

    if (result == null || !mounted) {
      return;
    }

    final success = await _controller.saveCycle(
      cycleId: cycle?.id,
      name: result.name,
      level: result.level,
      isActive: result.isActive,
    );

    if (!mounted) {
      return;
    }

    final message = _controller.successMessage ?? _controller.errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColors.success : AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleStatus(CicloModel cycle) async {
    final success = await _controller.toggleStatus(cycle);

    if (!mounted) {
      return;
    }

    final message = _controller.successMessage ?? _controller.errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openCycleForm(),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nuevo curso',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.surface),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizes.gapV12,
                  Text(
                    'Gestión de Cursos',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.gapV12,
                  CarreraSearchBar(
                    onChanged: _controller.setSearchQuery,
                    hintText: 'Buscar curso...',
                  ),
                  AppSizes.gapV12,
                  Text(
                    '${_controller.filteredCycles.length} cursos registrados',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV12,
                  Expanded(
                    child: _controller.filteredCycles.isEmpty
                        ? AdminEmptyState(
                            title: _controller.searchQuery.isNotEmpty
                                ? 'No se encontraron cursos'
                                : 'Aún no hay cursos registrados',
                            subtitle: _controller.searchQuery.isNotEmpty
                                ? 'Prueba con otro criterio de búsqueda.'
                                : 'Crea el primer curso para comenzar.',
                            icon: Icons.school_rounded,
                            accentColor: AppColors.primary,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.filteredCycles.length,
                            separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final cycle = _controller.filteredCycles[index];
                              return CicloCard(
                                cycle: cycle,
                                onTap: () => _openCycleForm(cycle: cycle),
                                onToggleStatus: () => _toggleStatus(cycle),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
