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
      margin: const EdgeInsets.only(bottom: AppTamanos.sm),
      decoration: BoxDecoration(
        color: selected
            ? AppColores.primary.withValues(alpha: 0.08)
            : AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
        border: Border.all(
          color: selected ? AppColores.primary : AppColores.outline,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColores.primary.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: blocked ? null : onChanged,
        activeColor: AppColores.primary,
        checkColor: AppColores.surface,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: CircleAvatar(
          backgroundColor: selected
              ? AppColores.primary
              : AppColores.primary.withValues(alpha: 0.12),
          foregroundColor: selected ? AppColores.surface : AppColores.primary,
          child: Text(name.isEmpty ? 'E' : name[0].toUpperCase()),
        ),
        title: Text(
          name,
          style: AppEstiloTexto.bodyBold,
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
