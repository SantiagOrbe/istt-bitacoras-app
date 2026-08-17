import 'package:bitacoras_app/features/admin/admin.dart';

class GestionUsuarioBody extends StatelessWidget {
  final List<UsuarioModel> users;
  final ValueChanged<UsuarioModel> onUserTap;
  final ValueChanged<String> onSearchChanged;

  const GestionUsuarioBody({
    super.key,
    required this.users,
    required this.onUserTap,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSizes.gapV12,

          Text(
            'Gestión de Usuarios',
            style: AppTextStyles.heading.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          AppSizes.gapV12,

          // Buscador interno de usuarios
          UsuarioSearchBar(onChanged: onSearchChanged),

          AppSizes.gapV16,

          const UsuarioMetricasHeader(),

          AppSizes.gapV16,

          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron usuarios',
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: AppColors.divider,
                    ),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UsuarioListTile(
                        user: user,
                        onTap: () => onUserTap(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}