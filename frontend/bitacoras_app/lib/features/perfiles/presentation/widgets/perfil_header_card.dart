import 'package:bitacoras_app/features/perfiles/perfiles.dart';

class PerfilHeaderCard extends StatelessWidget {
  final UsuarioModel user;

  const PerfilHeaderCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = user.name.isNotEmpty ? user.name : 'Usuario';
    final initialLetter = displayName[0].toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.infoSoft.withValues(alpha: 0.72),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          const BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar con borde Verde Institucional
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.primary,
              child: Text(
                initialLetter,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.surface,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          AppSizes.gapV12,

          // Nombre del Usuario
          Text(
            displayName,
            style: AppTextStyles.title.copyWith(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSizes.gapV8,

          // Badge con el Rol
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warningSoft,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.warning),
            ),
            child: Text(
              user.role.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (user.company?.isNotEmpty ?? false) ...[
            AppSizes.gapV12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Empresa: ${user.company!}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ] else if (_puedeMostrarEmpresa) ...[
            AppSizes.gapV12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: AppColors.error,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Sin empresa asignada',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool get _puedeMostrarEmpresa =>
      user.role == RolUsuarioModel.student ||
      user.role == RolUsuarioModel.academicTutor ||
      user.role == RolUsuarioModel.companyTutor;
}