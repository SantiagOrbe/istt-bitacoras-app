import 'package:bitacoras_app/features/admin/admin.dart';

class EstudianteParaleloCard extends StatelessWidget {
  final Map<String, dynamic> student;
  final bool selected;
  final bool blocked;
  final ValueChanged<bool?> onChanged;

  const EstudianteParaleloCard({
    super.key,
    required this.student,
    required this.selected,
    this.blocked = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final name = student['nombre'] as String? ?? 'Sin nombre';
    final email = student['email'] as String? ?? '';
    final cedula = student['cedula'] as String? ?? '';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.outline,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: blocked ? null : onChanged,
        activeColor: AppColors.primary,
        checkColor: AppColors.surface,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: CircleAvatar(
          backgroundColor: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.12),
          foregroundColor: selected ? AppColors.surface : AppColors.primary,
          child: Text(name.isEmpty ? 'E' : name[0].toUpperCase()),
        ),
        title: Text(
          name,
          style: AppTextStyles.bodyBold,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          [
            email,
            if (cedula.isNotEmpty) 'Cédula: $cedula',
            if (blocked) 'Ya pertenece a otro paralelo',
          ].join('\n'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
