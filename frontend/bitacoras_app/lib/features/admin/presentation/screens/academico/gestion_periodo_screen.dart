import 'package:bitacoras_app/features/admin/admin.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = GestionPeriodoController(repository: widget.adminRepository);
    _controller.loadPeriods();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openPeriodForm({PeriodoModel? period}) async {
    final result = await showModalBottomSheet<PeriodoFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PeriodoFormSheet(period: period),
    );

    if (result == null || !mounted) {
      return;
    }

    final success = await _controller.savePeriod(
      periodId: period?.id,
      name: result.name,
      startDate: result.startDate,
      endDate: result.endDate,
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

  Future<void> _toggleStatus(PeriodoModel period) async {
    if (period.isActive) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Desactivar período'),
          content: const Text(
            'Si desactivas este período, también quedarán bloqueadas las configuraciones de carreras y semestres asociadas a este periodo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    final success = period.isActive
        ? await _controller.deactivatePeriod(period)
        : await _controller.activatePeriod(period);

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
            onPressed: () => _openPeriodForm(),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nuevo período',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.surface),
            ),
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.md,
                      AppSizes.md,
                      AppSizes.md,
                      AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.outline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.secondary,
                                    AppColors.warning,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                              ),
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                color: AppColors.surface,
                              ),
                            ),
                            AppSizes.gapH12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Períodos lectivos',
                                    style: AppTextStyles.title,
                                  ),
                                  Text(
                                    'Vigencia académica y prácticas institucionales',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${_controller.filteredPeriods.length}',
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.primary,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        AppSizes.gapV16,
                        CarreraSearchBar(
                          onChanged: _controller.setSearchQuery,
                          hintText: 'Buscar período lectivo...',
                        ),
                      ],
                    ),
                  ),
                  AppSizes.gapV16,
                  Expanded(
                    child: _controller.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : _controller.filteredPeriods.isEmpty
                        ? PeriodoEmptyState(
                            hasSearchQuery: _controller.searchQuery.isNotEmpty,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.filteredPeriods.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final period = _controller.filteredPeriods[index];
                              return PeriodoCard(
                                period: period,
                                onTap: () => _openPeriodForm(period: period),
                                onToggleStatus: () => _toggleStatus(period),
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
