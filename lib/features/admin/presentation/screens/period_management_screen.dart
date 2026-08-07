import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/presentation/controllers/period_management_controller.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/career_search_bar.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/period_card.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/period_empty_state.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/period_form_sheet.dart';

class PeriodManagementScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAdminRepository adminRepository;

  const PeriodManagementScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<PeriodManagementScreen> createState() => _PeriodManagementScreenState();
}

class _PeriodManagementScreenState extends State<PeriodManagementScreen> {
  late final PeriodManagementController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PeriodManagementController(repository: widget.adminRepository);
    _controller.loadPeriods();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openPeriodForm({PeriodModel? period}) async {
    final result = await showModalBottomSheet<PeriodFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PeriodFormSheet(period: period),
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

  Future<void> _toggleStatus(PeriodModel period) async {
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
          appBar: HomeAppBar(
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
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizes.gapV12,
                  Text(
                    'Gestión de Períodos Lectivos',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.gapV12,
                  CareerSearchBar(
                    onChanged: _controller.setSearchQuery,
                    hintText: 'Buscar período...',
                  ),
                  AppSizes.gapV12,
                  Text(
                    '${_controller.filteredPeriods.length} períodos registrados',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV12,
                  Expanded(
                    child: _controller.filteredPeriods.isEmpty
                        ? PeriodEmptyState(
                            hasSearchQuery: _controller.searchQuery.isNotEmpty,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.filteredPeriods.length,
                            separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final period = _controller.filteredPeriods[index];
                              return PeriodCard(
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
