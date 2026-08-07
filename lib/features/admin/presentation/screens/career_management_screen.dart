import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/career_model.dart';
import 'package:bitacoras_app/features/admin/presentation/controllers/career_management_controller.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/career_card.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/career_empty_state.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/career_form_sheet.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/career_search_bar.dart';

class CareerManagementScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAdminRepository adminRepository;

  const CareerManagementScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<CareerManagementScreen> createState() => _CareerManagementScreenState();
}

class _CareerManagementScreenState extends State<CareerManagementScreen> {
  late final CareerManagementController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CareerManagementController(repository: widget.adminRepository);
    _controller.loadCareers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCareerForm() async {
    final newCareer = await showModalBottomSheet<CareerModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CareerFormSheet(),
    );

    if (newCareer == null || !mounted) {
      return;
    }

    final success = await _controller.createCareer(newCareer);
    if (!success && mounted && _controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage!),
          backgroundColor: AppColors.error,
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
            onPressed: _openCareerForm,
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nueva carrera',
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
                    'Gestión de Carreras',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.gapV12,
                  CareerSearchBar(onChanged: _controller.setSearchQuery),
                  AppSizes.gapV12,
                  Text(
                    '${_controller.filteredCareers.length} carreras registradas',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.gapV12,
                  Expanded(
                    child: _controller.filteredCareers.isEmpty
                        ? CareerEmptyState(
                            hasSearchQuery: _controller.searchQuery.isNotEmpty,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.filteredCareers.length,
                            separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
                            itemBuilder: (context, index) {
                              final career = _controller.filteredCareers[index];
                              return CareerCard(
                                career: career,
                                onTap: () => context.push(
                                  AppRoutes.careerDetail,
                                  extra: career,
                                ),
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
