import 'package:bitacoras_app/features/admin/admin.dart';

class TarjetaUsuarioLista extends StatelessWidget {
  final UsuarioModel user;
  final VoidCallback onTap;

  const TarjetaUsuarioLista({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(user.role.name);

    return InkWell(
      onTap: onTap,
      hoverColor: AppColores.secondary.withValues(alpha: 0.06),
      splashColor: AppColores.secondary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTamanos.sm,
          horizontal: AppTamanos.md,
        ),
        decoration: BoxDecoration(
          color: AppColores.surface,
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          border: Border.all(color: AppColores.outline),
        ),
        child: Row(
          children: [
            // Avatar con iniciales del usuario
            CircleAvatar(
              radius: 22,
              backgroundColor: roleColor.withValues(alpha: 0.12),
              child: Text(
                user.initials,
                style: AppEstiloTexto.bodyBold.copyWith(
                  color: roleColor,
                  fontSize: 13,
                ),
              ),
            ),
            AppTamanos.gapH12,

            // Nombre, CI y Rol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppEstiloTexto.bodyBold.copyWith(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppTamanos.gapV4,
                  Text(
                    'CI: ${user.cedula ?? 'No registrada'} • ${user.role.label}',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            AppTamanos.gapH8,

            // Badge de Estado (Activo / Inactivo)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTamanos.sm,
                vertical: AppTamanos.xs,
              ),
              decoration: BoxDecoration(
                color: user.isActive
                    ? AppColores.success.withValues(alpha: 0.12)
                    : AppColores.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
              ),
              child: Text(
                user.isActive ? 'Activo' : 'Inactivo',
                style: AppEstiloTexto.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: user.isActive ? AppColores.success : AppColores.error,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColores.textSecondary,
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
        return AppColores.primary;
      case 'tutor':
        return AppColores.secondary;
      default:
        return AppColores.success;
    }
  }
}
