import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';
import '../../domain/models/user_model.dart';
import '../../../../app/routes/app_routes.dart';

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
          // Encabezado del menú
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0F4C81), // Azul institucional
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
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

          // --- OPCIONES DEL MENÚ ---
          
          // 1. Inicio
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFF0F4C81)),
            title: const Text("Inicio"),
            onTap: () {
              Navigator.pop(context); 
              context.go(AppRoutes.studentHome);
            },
          ),

          // 2. Registrar Asistencia
          ListTile(
            leading: const Icon(Icons.app_registration_outlined, color: Color(0xFF0F4C81)),
            title: const Text("Registrar Asistencia"),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.attendance);
            },
          ),

          // 3. Historial de Prácticas
          ListTile(
            leading: const Icon(Icons.history_toggle_off_rounded, color: Color(0xFF0F4C81)),
            title: const Text("Historial de Prácticas"),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.history);
            },
          ),

          // 4. Reportes y Bitácoras
          ListTile(
            leading: const Icon(Icons.description_outlined, color: Color(0xFF0F4C81)),
            title: const Text("Reportes y Bitácoras"),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.reports);
            },
          ),

          const Divider(),

          // 5. Mi Perfil (Pendiente de implementación de pantalla)
          ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xFF0F4C81)),
            title: const Text("Mi Perfil"),
            onTap: () {
              Navigator.pop(context);
                context.push(AppRoutes.profile); 
            },
          ),

          const Spacer(), // Empuja el botón de cerrar sesión al fondo
          const Divider(),

          // 6. Botón de Cerrar Sesión
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
              context.go(AppRoutes.login);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}