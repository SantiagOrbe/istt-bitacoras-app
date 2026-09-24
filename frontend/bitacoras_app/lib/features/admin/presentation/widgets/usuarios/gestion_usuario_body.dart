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
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.md,
              AppSizes.md,
              AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.outline),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: const Icon(
                        Icons.manage_accounts_outlined,
                        color: AppColors.secondary,
                      ),
                    ),
                    AppSizes.gapH12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gestión de usuarios', style: AppTextStyles.title),
                          Text(
                            'Directorio y permisos institucionales',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$totalUsers registros',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppSizes.gapV16,
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
                  isExpanded: true,
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
              ],
            ),
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
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            size: 36,
                            color: AppColors.textDisabled,
                          ),
                          AppSizes.gapV8,
                          Text(
                            'No se encontraron usuarios',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (context, index) => AppSizes.gapV8,
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
        selectedColor: AppColors.secondary.withValues(alpha: 0.16),
        backgroundColor: AppColors.background,
        side: BorderSide(
          color: selected ? AppColors.secondary : AppColors.outline,
        ),
        checkmarkColor: AppColors.primary,
        labelStyle: AppTextStyles.caption.copyWith(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
