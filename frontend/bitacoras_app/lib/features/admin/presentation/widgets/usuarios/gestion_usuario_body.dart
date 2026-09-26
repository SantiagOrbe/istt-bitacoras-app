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
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppTamanos.md,
            AppTamanos.md,
            AppTamanos.md,
            AppTamanos.sm,
          ),
          decoration: BoxDecoration(
            color: AppColores.surface,
            borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
            border: Border.all(color: AppColores.outline),
            boxShadow: [
              BoxShadow(
                color: AppColores.shadow,
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
                      color: AppColores.secondary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(
                        AppTamanos.radiusSm,
                      ),
                    ),
                    child: const Icon(
                      Icons.manage_accounts_outlined,
                      color: AppColores.secondary,
                    ),
                  ),
                  AppTamanos.gapH12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gestión de usuarios',
                          style: AppEstiloTexto.title,
                        ),
                        Text(
                          'Directorio y permisos institucionales',
                          style: AppEstiloTexto.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$totalUsers registros',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              AppTamanos.gapV16,
              UsuarioSearchBar(onChanged: onSearchChanged),
              AppTamanos.gapV12,

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

              AppTamanos.gapV8,

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
                  DropdownMenuItem(
                    value: 'estudiante',
                    child: Text('Estudiantes'),
                  ),
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
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Administradores'),
                  ),
                ],
                onChanged: onRoleChanged,
              ),
            ],
          ),
        ),

        AppTamanos.gapV16,

        CabeceraMetricasUsuario(
          totalUsers: totalUsers,
          totalStudents: totalStudents,
          totalTutors: totalTutors,
          totalActive: totalActive,
        ),

        AppTamanos.gapV16,

        users.isEmpty
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(AppTamanos.lg),
                  decoration: BoxDecoration(
                    color: AppColores.surface,
                    borderRadius: BorderRadius.circular(
                      AppTamanos.radiusMd,
                    ),
                    border: Border.all(color: AppColores.outline),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.people_outline_rounded,
                        size: 36,
                        color: AppColores.textDisabled,
                      ),
                      AppTamanos.gapV8,
                      Text(
                        'No se encontraron usuarios',
                        style: AppEstiloTexto.bodyMedium.copyWith(
                          color: AppColores.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (context, index) => AppTamanos.gapV8,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return TarjetaUsuarioLista(
                    user: user,
                    onTap: () => onUserTap(user),
                  );
                },
              ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTamanos.md,
        AppTamanos.sm,
        AppTamanos.md,
        0,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: content,
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
      padding: const EdgeInsets.only(right: AppTamanos.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColores.secondary.withValues(alpha: 0.16),
        backgroundColor: AppColores.background,
        side: BorderSide(
          color: selected ? AppColores.secondary : AppColores.outline,
        ),
        checkmarkColor: AppColores.primary,
        labelStyle: AppEstiloTexto.caption.copyWith(
          color: selected ? AppColores.primary : AppColores.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
