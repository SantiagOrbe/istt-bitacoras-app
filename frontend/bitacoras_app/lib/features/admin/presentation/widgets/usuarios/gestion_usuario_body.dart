import 'package:bitacoras_app/features/admin/admin.dart';

class GestionUsuarioBody extends StatelessWidget {
  final List<UsuarioModel> users;
  final int totalUsers;
  final int totalStudents;
  final int totalTutors;
  final int totalActive;
  final ValueChanged<UsuarioModel> onUserTap;
  final ValueChanged<String> onSearchChanged;
  final String? roleFilter;
  final bool? activeFilter;
  final ValueChanged<String?> onRoleChanged;
  final ValueChanged<bool?> onActiveChanged;

  const GestionUsuarioBody({
    super.key,
    required this.users,
    required this.totalUsers,
    required this.totalStudents,
    required this.totalTutors,
    required this.totalActive,
    required this.onUserTap,
    required this.onSearchChanged,
    required this.roleFilter,
    required this.activeFilter,
    required this.onRoleChanged,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSizes.gapV12,

          Text(
            'Gestión de Usuarios',
            style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary),
          ),

          AppSizes.gapV12,

          // Buscador interno de usuarios
          UsuarioSearchBar(onChanged: onSearchChanged),

          AppSizes.gapV12,

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todos',
                  selected: activeFilter == null,
                  onSelected: (_) => onActiveChanged(null),
                ),
                _FilterChip(
                  label: 'Activos',
                  selected: activeFilter == true,
                  onSelected: (_) => onActiveChanged(true),
                ),
                _FilterChip(
                  label: 'Inactivos',
                  selected: activeFilter == false,
                  onSelected: (_) => onActiveChanged(false),
                ),
              ],
            ),
          ),

          AppSizes.gapV8,

          DropdownButtonFormField<String?>(
            initialValue: roleFilter,
            decoration: const InputDecoration(
              labelText: 'Filtrar por rol',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            items: const [
              DropdownMenuItem<String?>(
                value: null,
                child: Text('Todos los roles'),
              ),
              DropdownMenuItem(value: 'estudiante', child: Text('Estudiantes')),
              DropdownMenuItem(value: 'docente', child: Text('Docentes')),
              DropdownMenuItem(
                value: 'tutor_academico',
                child: Text('Tutores académicos'),
              ),
              DropdownMenuItem(
                value: 'tutor_empresarial',
                child: Text('Tutores empresariales'),
              ),
              DropdownMenuItem(
                value: 'coordinador',
                child: Text('Coordinadores'),
              ),
              DropdownMenuItem(
                value: 'responsable_practicas',
                child: Text('Responsables de prácticas'),
              ),
              DropdownMenuItem(value: 'admin', child: Text('Administradores')),
            ],
            onChanged: onRoleChanged,
          ),

          AppSizes.gapV16,

          UsuarioMetricasHeader(
            totalUsers: totalUsers,
            totalStudents: totalStudents,
            totalTutors: totalTutors,
            totalActive: totalActive,
          ),

          AppSizes.gapV16,

          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron usuarios',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: AppColors.divider),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UsuarioListTile(
                        user: user,
                        onTap: () => onUserTap(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColors.infoSoft,
        checkmarkColor: AppColors.primary,
        labelStyle: AppTextStyles.caption.copyWith(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
