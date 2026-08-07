import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/admin.dart';



class UserManagementScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAdminRepository adminRepository;

  const UserManagementScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late final UserManagementController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UserManagementController(repository: widget.adminRepository);
    _controller.fetchUsers();
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
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nuevo Usuario',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.surface),
            ),
          ),
          body: SafeArea(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : UserManagementBody(
                    users: _controller.filteredUsers,
                    onUserTap: (user) => context.push(
                      AppRoutes.userDetail,
                      extra: user,
                    ),
                    onSearchChanged: _controller.setSearchQuery,
                  ),
          ),
        );
      },
    );
  }
}