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
      padding: const EdgeInsets.all(AppTamanos.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColores.surface,
            AppColores.infoSoft.withValues(alpha: 0.72),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        border: Border.all(
          color: AppColores.primary.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColores.primary.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          const BoxShadow(
            color: AppColores.shadow,
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
              color: AppColores.success,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: AppColores.primary,
              child: Text(
                initialLetter,
                style: AppEstiloTexto.heading.copyWith(
                  color: AppColores.surface,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          AppTamanos.gapV12,

          // Nombre del Usuario
          Text(
            displayName,
            style: AppEstiloTexto.title.copyWith(
              fontSize: 18,
              color: AppColores.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppTamanos.gapV8,

          // Badge con el Rol
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColores.warningSoft,
              borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
              border: Border.all(color: AppColores.warning),
            ),
            child: Text(
              user.role.label,
              style: AppEstiloTexto.caption.copyWith(
                color: AppColores.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (user.company?.isNotEmpty ?? false) ...[
            AppTamanos.gapV12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: AppColores.secondary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Empresa: ${user.company!}',
                    style: AppEstiloTexto.bodyMedium.copyWith(
                      color: AppColores.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ] else if (_puedeMostrarEmpresa) ...[
            AppTamanos.gapV12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: AppColores.error,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Sin empresa asignada',
                    style: AppEstiloTexto.bodyMedium.copyWith(
                      color: AppColores.error,
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