import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

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

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      elevation: selected ? 2 : 0,
      color: selected
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outline,
        ),
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: blocked ? null : onChanged,
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