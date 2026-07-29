import 'package:bitacoras_app/features/home/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user;

  const HomeAppBar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0F4C81), // Azul institucional del logo
      centerTitle: true,
      
      // 👈 Forzar a que el menú del Drawer (y cualquier flecha) sea blanco
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      
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
              backgroundColor: Colors.white.withOpacity(0.2), // Avatar translúcido
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => context.push(AppRoutes.profile),
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