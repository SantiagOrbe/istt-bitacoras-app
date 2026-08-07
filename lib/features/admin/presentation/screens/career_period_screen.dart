import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/career_period_body.dart';
import 'package:bitacoras_app/features/admin/presentation/screens/widgets/save_bottom_bar.dart';
import 'package:bitacoras_app/features/screens.dart';
import 'package:bitacoras_app/shared/exports.dart';

import '../../domain/repositories/i_admin_repository.dart';
import '../controllers/career_period_controller.dart';


class CareerPeriodScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAdminRepository adminRepository;

  const CareerPeriodScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<CareerPeriodScreen> createState() => _CareerPeriodScreenState();
}

class _CareerPeriodScreenState extends State<CareerPeriodScreen> {
  late final CareerPeriodController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CareerPeriodController(repository: widget.adminRepository);
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveConfiguration();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Configuración guardada exitosamente.',
            style: AppTextStyles.body.copyWith(color: AppColors.surface),
          ),
          backgroundColor: AppColors.primary,
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
          body: _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CareerPeriodBody(
                  periods: _controller.periods,
                  careers: _controller.careers,
                  selectedPeriodId: _controller.selectedPeriodId,
                  configs: _controller.configs,
                  getConfigKey: _controller.getConfigKey,
                  onPeriodChanged: _controller.selectPeriod,
                  onToggleSemester: _controller.toggleSemester,
                ),
          bottomNavigationBar: _controller.isLoading
              ? null
              : SaveBottomBar(onSave: _handleSave),
        );
      },
    );
  }
}