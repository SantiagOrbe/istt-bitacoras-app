import 'package:bitacoras_app/app/apps.dart';



class UserDetailScreen extends StatefulWidget {
  final UserModel user;
  final IAdminRepository adminRepository;

  const UserDetailScreen({
    super.key,
    required this.user,
    required this.adminRepository,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late final UserDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UserDetailController(
      repository: widget.adminRepository,
      initialUser: widget.user,
    );
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (!mounted) return;

    if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (_controller.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.successMessage!),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Eliminar Usuario', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          '¿Está seguro de eliminar a ${_controller.user.name}? Esta acción no se puede deshacer.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.surface,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await _controller.deleteUser();
      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: HomeAppBar(
            user: _controller.user,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          backgroundColor: AppColors.background,
          body: _controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        
                        const SizedBox(height: 12),
                        UserDetailHeader(
                          user: _controller.user,
                          onToggleStatus: _controller.toggleUserStatus,
                          isLoading: _controller.isLoading,
                        ),
                        const SizedBox(height: 16),
                        UserInfoCard(
                          controller: _controller,
                        ),
                        const SizedBox(height: 24),
                        UserDetailActionButtons(
                          isEditing: _controller.isEditing,
                          onSave: _controller.saveChanges,
                          onDelete: _confirmDelete,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}