import 'package:bitacoras_app/features/admin/admin.dart';

class CabeceraDetalleUsuario extends StatelessWidget {
  final UsuarioModel user;
  final VoidCallback onToggleStatus;
  final bool isLoading;

  const CabeceraDetalleUsuario({
    super.key,
    required this.user,
    required this.onToggleStatus,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
        border: Border.all(color: AppColores.outline),
        boxShadow: [
          BoxShadow(
            color: AppColores.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColores.primary.withValues(alpha: 0.1),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColores.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: AppEstiloTexto.title.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: AppEstiloTexto.body.copyWith(
              color: AppColores.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(user.role.label),
                backgroundColor: AppColores.infoSoft,
                labelStyle: TextStyle(
                  color: AppColores.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: isLoading ? null : onToggleStatus,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: user.isActive
                        ? AppColores.successSoft
                        : AppColores.errorSoft,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: user.isActive
                          ? AppColores.success
                          : AppColores.error,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        user.isActive
                            ? Icons.check_circle_outline
                            : Icons.block_outlined,
                        size: 16,
                        color: user.isActive
                            ? AppColores.success
                            : AppColores.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: user.isActive
                              ? AppColores.success
                              : AppColores.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
