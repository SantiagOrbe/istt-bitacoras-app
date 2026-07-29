import 'package:bitacoras_app/features/profile/domain/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/profile_info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  StudentProfileModel _getMockProfile() {
    return StudentProfileModel(
      id: '1',
      nombre: 'Santiago',
      apellido: 'Orbe',
      correo: 'santiago.orbe@isttena.edu.ec',
      telefono: '0991234567',
      rol: 'Estudiante',
      estado: 'Activo',
      cedula: '1500123456',
      matricula: 'EST-2026-004',
      tutorAcademico: 'Ing. Carlos Mendoza',
      tutorEmpresarial: 'Ing. María López',
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _getMockProfile();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F4C81),
        elevation: 0,
        centerTitle: true,
        // 👈 Flecha de regreso manual garantizada
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(), 
        ),
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header del Perfil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF0F4C81),
                    child: Text(
                      profile.nombre[0].toUpperCase(),
                      style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.fullName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F4C81)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${profile.rol.toUpperCase()} • ${profile.estado.toUpperCase()}',
                      style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Card 1: Información Académica y Personal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Datos de la Cuenta',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F4C81)),
                  ),
                  const Divider(height: 20),
                  ProfileInfoTile(icon: Icons.badge_outlined, title: 'Cédula de Identidad', value: profile.cedula),
                  ProfileInfoTile(icon: Icons.confirmation_number_outlined, title: 'Número de Matrícula', value: profile.matricula),
                  ProfileInfoTile(icon: Icons.email_outlined, title: 'Correo Institucional', value: profile.correo),
                  ProfileInfoTile(icon: Icons.phone_android_outlined, title: 'Teléfono de Contacto', value: profile.telefono),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card 2: Tutores Asignados
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Supervisión de Prácticas',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F4C81)),
                  ),
                  const Divider(height: 20),
                  ProfileInfoTile(icon: Icons.school_outlined, title: 'Tutor Académico', value: profile.tutorAcademico),
                  ProfileInfoTile(icon: Icons.business_center_outlined, title: 'Tutor Empresarial', value: profile.tutorEmpresarial),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}