import 'package:flutter/material.dart';
import '../../models/user_role.dart'; // Importamos el enum de roles para las condiciones

class GreetingCard extends StatelessWidget {
  final String name;
  final UserRole role;

  const GreetingCard({
    super.key,
    required this.name,
    required this.role,
  });

  // Método auxiliar para obtener el mensaje adaptado a cada rol
  String _getSubtitleByRole() {
    switch (role) {
      case UserRole.student:
        return "Bienvenido a tu jornada de prácticas";
      case UserRole.academicTutor:
        return "Panel de seguimiento y tutorías académicas";
      case UserRole.companyTutor:
        return "Panel de supervisión del tutor empresarial";
      case UserRole.coordinator:
        return "Coordinación y control general de prácticas";
      case UserRole.practiceManager:
        return "Gestión de vinculación y responsables de prácticas";
      case UserRole.teacher:
        return "Módulo de docentes y evaluaciones";
      case UserRole.admin:
        return "Consola de administración del sistema";
      default:
        return "Bienvenido al sistema de bitácoras";
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = name.split(' ').first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F4C81).withOpacity(0.08), // Azul institucional suave
            const Color(0xFFF1F5F9), // Slate claro
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hola, $firstName",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F4C81),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _getSubtitleByRole(),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}