import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/parallel_model.dart';
import 'package:bitacoras_app/features/admin/presentation/controllers/parallel_management_controller.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/admin_empty_state.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/career_search_bar.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/parallel_card.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/parallel_form_sheet.dart';

class ParallelManagementScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAdminRepository adminRepository;

  const ParallelManagementScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<ParallelManagementScreen> createState() => _ParallelManagementScreenState();
}

class _ParallelManagementScreenState extends State<ParallelManagementScreen> {
  late final ParallelManagementController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ParallelManagementController(repository: widget.adminRepository);
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openParallelForm({ParallelModel? parallel}) async {
    if (_controller.cycles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero crea al menos un curso.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await showModalBottomSheet<ParallelFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ParallelFormSheet(
        cycles: _controller.cycles,
        parallel: parallel,
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    final success = await _controller.saveParallel(
      parallelId: parallel?.id,
      cycleId: result.cycleId,
      name: result.name,
      jornada: result.jornada,
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

  Future<void> _toggleStatus(ParallelModel parallel) async {
    final success = await _controller.toggleStatus(parallel);

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
          appBar: HomeAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openParallelForm(),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nuevo paralelo',
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
                    'Gestión de Paralelos',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.gapV12,
                  CareerSearchBar(
                    onChanged: _controller.setSearchQuery,
                    hintText: 'Buscar paralelo...',
                  ),
                  AppSizes.gapV12,
                  DropdownButtonFormField<String?>(
                    value: _controller.selectedCycleId,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por curso',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Todos los cursos'),
                      ),
                      ..._controller.cycles.map(
                        (cycle) => DropdownMenuItem<String?>(
                          value: cycle.id,
                          child: Text('${cycle.name} (Nivel ${cycle.level})'),
                        ),
                      ),
                    ],
                    onChanged: _controller.setSelectedCycle,
                  ),
                  AppSizes.gapV12,
                  Text(
                    '${_controller.filteredParallels.length} paralelos registrados',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV12,
                  Expanded(
                    child: _controller.filteredParallels.isEmpty
                        ? AdminEmptyState(
                            title: _controller.searchQuery.isNotEmpty
                                ? 'No se encontraron paralelos'
                                : 'Aún no hay paralelos registrados',
                            subtitle: _controller.searchQuery.isNotEmpty
                                ? 'Prueba con otro criterio de búsqueda.'
                                : 'Crea el primer paralelo para comenzar.',
                            icon: Icons.groups_rounded,
                            accentColor: AppColors.secondary,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.filteredParallels.length,
                            separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final parallel = _controller.filteredParallels[index];
                              return ParallelCard(
                                parallel: parallel,
                                cycleName: _controller.getCycleName(parallel.cycleId),
                                onTap: () => _openParallelForm(parallel: parallel),
                                onToggleStatus: () => _toggleStatus(parallel),
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
