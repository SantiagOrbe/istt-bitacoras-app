import 'package:bitacoras_app/config/constants/app_colors.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes/app_routes.dart';

class InicioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UsuarioModel user;
  final bool? showDrawerButton;
  final bool? showBackButton;
  final VoidCallback? onBackPressed;

  const InicioAppBar({
    super.key,
    required this.user,
    this.showDrawerButton,
    this.showBackButton,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = context.canPop();

    final bool shouldShowBack = showBackButton ?? canPop;

    final bool shouldShowDrawer = showDrawerButton ?? (!shouldShowBack);

    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary, 
      centerTitle: true,
      automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      leading: shouldShowBack
          ? BackButton(
              color: Colors.white,
              onPressed: onBackPressed ?? () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.studentHome);
                }
              },
            )
          : shouldShowDrawer
              ? IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: 'Abrir menú',
                )
              : null,
      title: const Text(
        "IST Tena Prácticas",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => context.push(AppRoutes.perfil),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}