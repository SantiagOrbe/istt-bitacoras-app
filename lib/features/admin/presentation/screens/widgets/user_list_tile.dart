import 'package:bitacoras_app/features/admin/domain/models/user_managment_model.dart';
import 'package:bitacoras_app/shared/exports.dart';

class UserListTile extends StatelessWidget {
  final ManagedUser user;
  final VoidCallback onTap;

  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(user.role);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.sm,
          horizontal: AppSizes.xs,
        ),
        child: Row(
          children: [
            // Avatar con iniciales del usuario
            CircleAvatar(
              radius: 20,
              backgroundColor: roleColor.withValues(alpha: 0.12),
              child: Text(
                user.initials,
                style: AppTextStyles.bodyBold.copyWith(
                  color: roleColor,
                  fontSize: 13,
                ),
              ),
            ),
            AppSizes.gapH8,

            // Nombre, CI y Rol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSizes.gapV4,
                  Text(
                    'CI: ${user.idNumber} • ${user.role}',
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            AppSizes.gapH8,

            // Badge de Estado (Activo / Inactivo)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: user.isActive
                    ? AppColors.success.withValues(alpha: 0.12)
                    : AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                user.isActive ? 'Activo' : 'Inactivo',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: user.isActive ? AppColors.success : AppColors.error,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'estudiante':
        return AppColors.primary;
      case 'tutor':
        return AppColors.secondary;
      default:
        return AppColors.success;
    }
  }
}