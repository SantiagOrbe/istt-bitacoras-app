import 'package:bitacoras_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/user_model.dart';

import 'package:bitacoras_app/features/auth/presentation/screens/login_screen.dart';


class HomeDrawer extends StatelessWidget {
  final UserModel user;

  const HomeDrawer({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Encabezado del menú con el color azul de tu logo
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0F4C81), // Azul institucional del logo
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user.fullName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F4C81),
                ),
              ),
            ),
            accountName: Text(
              user.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              user.email,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ),

          // Elementos del menú
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFF0F4C81)),
            title: const Text("Inicio"),
            onTap: () {
              Navigator.pop(context); // Cierra el menú lateral
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xFF0F4C81)),
            title: const Text("Mi Perfil"),
            onTap: () {
              Navigator.pop(context);
              // Aquí podrías navegar a la pantalla de perfil
            },
          ),

          const Spacer(), // Empuja el botón de cerrar sesión hacia el fondo
          const Divider(),

          // Botón de Cerrar Sesión
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              "Cerrar Sesión",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(); // Cierra Drawer
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // Borra toda la pila anterior
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}