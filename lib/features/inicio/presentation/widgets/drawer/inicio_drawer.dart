import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/item_menu_model.dart';

class InicioDrawer extends StatelessWidget {
  final UsuarioModel user;
  final List<SeccionMenuModel> sections;

  const InicioDrawer({
    super.key,
    required this.user,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          // Header con el azul principal (0xFF0F52BA) y acentos en verde hoja
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success, width: 2.5), // Toque verde
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.surface,
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            accountName: Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.surface,
                    ),
                  ),
                ),
                // Badge con el verde del IST Tena
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            accountEmail: Text(
              user.email,
              style: TextStyle(
                color: AppColors.surface.withOpacity(0.85),
                fontSize: 13,
              ),
            ),
          ),

          // Secciones de menú
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: sections.length,
              separatorBuilder: (_, __) => const Divider(
                color: AppColors.divider,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final section = sections[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (section.title != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
                        child: Text(
                          section.title!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ...section.items.map(
                      (item) => ListTile(
                        leading: Icon(
                          item.icon,
                          color: AppColors.primary, // Iconos en Azul Petróleo
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        horizontalTitleGap: 0,
                        onTap: () {
                          Navigator.pop(context);
                          context.push(item.route);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const Divider(color: AppColors.divider, height: 1),

          // Mi Perfil
          ListTile(
            leading: const Icon(Icons.person_outline, color: AppColors.primary),
            title: const Text(
              'Mi Perfil',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            horizontalTitleGap: 0,
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.perfil);
            },
          ),

          // Cerrar Sesión
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            horizontalTitleGap: 0,
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.login);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}