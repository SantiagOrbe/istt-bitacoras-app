import 'package:bitacoras_app/features/admin/presentation/controllers/usuarios/usuario_detail_controller.dart';
import 'package:flutter/material.dart';

class UsuarioInfoCard extends StatelessWidget {
  final UsuarioDetailController controller;

  const UsuarioInfoCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Información General',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  controller.isEditing ? Icons.close : Icons.edit_outlined,
                  color: theme.colorScheme.primary,
                ),
                onPressed: controller.toggleEditMode,
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          if (controller.isEditing) ...[
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono / Celular',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula de Identidad',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.companyController,
              decoration: const InputDecoration(
                labelText: 'Empresa / Institución',
                prefixIcon: Icon(Icons.business_outlined),
              ),
            ),
          ] else ...[
            _InfoTile(
              icon: Icons.phone_outlined,
              label: 'Teléfono',
              value: controller.user.phone ?? 'No registrado',
            ),
            _InfoTile(
              icon: Icons.badge_outlined,
              label: 'Cédula',
              value: controller.user.cedula ?? 'No registrada',
            ),
            _InfoTile(
              icon: Icons.business_outlined,
              label: 'Empresa / Institución',
              value: controller.user.company ?? 'Sin empresa asignada',
            ),
            _InfoTile(
              icon: Icons.school_outlined,
              label: 'Carrera',
              value: controller.user.careerName ?? 'No asignada',
            ),
            _InfoTile(
              icon: Icons.calendar_today_outlined,
              label: 'Período',
              value: controller.user.periodName ?? 'No asignado',
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}