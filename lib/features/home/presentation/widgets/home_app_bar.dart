import 'package:bitacoras_app/features/home/models/user_model.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF0F4C81), // El azul exacto del logo institucional
      centerTitle: true,
      /* leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {}, // Para el menú lateral
      ), */
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
            backgroundColor: Colors.white.withOpacity(0.2), // Avatar translúcido estético
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}