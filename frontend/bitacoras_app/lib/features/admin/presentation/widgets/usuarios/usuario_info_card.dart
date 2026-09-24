import 'package:bitacoras_app/features/admin/admin.dart';


class UsuarioInfoCard extends StatelessWidget {
  final UsuarioDetailController controller;

  const UsuarioInfoCard({super.key, required this.controller});

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
            color: Colors.black.withValues(alpha: 0.05),
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
              validator: (value) =>
                  AdminValidators.letters(value, label: 'El nombre completo'),
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                prefixIcon: Icon(Icons.person_outline),
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.emailController,
              validator: AdminValidators.email,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RolUsuarioModel>(
              initialValue: controller.selectedRole,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Rol',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              items: RolUsuarioModel.values
                  .map(
                    (role) =>
                        DropdownMenuItem(value: role, child: Text(role.label)),
                  )
                  .toList(),
              onChanged: (role) {
                if (role != null) controller.setRole(role);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) => AdminValidators.ecuadorianPhone(
                value,
                required: false,
              ),
              decoration: const InputDecoration(
                labelText: 'Teléfono / Celular',
                prefixIcon: Icon(Icons.phone_outlined),
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.cedulaController,
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty
                  ? null
                  : AdminValidators.ecuadorianId(value),
              decoration: const InputDecoration(
                labelText: 'Cédula de Identidad',
                prefixIcon: Icon(Icons.badge_outlined),
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 12),
            if (controller.selectedRole == RolUsuarioModel.companyTutor) ...[
              TextFormField(
                controller: controller.cargoController,
                validator: (value) =>
                    AdminValidators.letters(value, label: 'El cargo'),
                decoration: const InputDecoration(
                  labelText: 'Cargo',
                  prefixIcon: Icon(Icons.work_outline),
                  errorMaxLines: 2,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (controller.selectedRole == RolUsuarioModel.student ||
                controller.selectedRole == RolUsuarioModel.companyTutor) ...[
              DropdownButtonFormField<String?>(
                initialValue: controller.selectedCompanyId,
                decoration: const InputDecoration(
                  labelText: 'Empresa / Institución',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Sin empresa asignada'),
                  ),
                  ...controller.companies.map(
                    (company) => DropdownMenuItem<String?>(
                      value: company.id,
                      child: Text(company.name),
                    ),
                  ),
                ],
                onChanged: controller.setCompany,
              ),
              const SizedBox(height: 12),
            ],
            if (controller.selectedRole == RolUsuarioModel.student ||
              controller.selectedRole == RolUsuarioModel.coordinator ||
              controller.selectedRole == RolUsuarioModel.academicTutor ||
              controller.selectedRole == RolUsuarioModel.practiceManager) ...[
              DropdownButtonFormField<String?>(
                initialValue: controller.selectedCareerId,
                decoration: const InputDecoration(
                  labelText: 'Carrera',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Sin carrera asignada'),
                  ),
                  ...controller.careers.map(
                    (career) => DropdownMenuItem<String?>(
                      value: career.id,
                      child: Text(career.name),
                    ),
                  ),
                ],
                onChanged: controller.setCareer,
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña (opcional)',
                prefixIcon: Icon(Icons.lock_outline),
                helperText: 'Déjalo vacío para conservar la actual.',
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
            if (_hasCompanyRole(controller.user.role))
              _InfoTile(
                icon: Icons.business_outlined,
                label: 'Empresa / Institución',
                value: controller.user.company ?? 'Sin empresa asignada',
              ),
            if (_hasCareerRole(controller.user.role))
              _InfoTile(
                icon: Icons.school_outlined,
                label: 'Carrera',
                value: controller.user.careerName ?? 'No asignada',
              ),
          ],
        ],
      ),
    );
  }

  bool _hasCompanyRole(RolUsuarioModel role) =>
      role == RolUsuarioModel.student ||
      role == RolUsuarioModel.companyTutor;

  bool _hasCareerRole(RolUsuarioModel role) =>
      role == RolUsuarioModel.student ||
      role == RolUsuarioModel.coordinator ||
      role == RolUsuarioModel.academicTutor ||
      role == RolUsuarioModel.practiceManager;
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
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
