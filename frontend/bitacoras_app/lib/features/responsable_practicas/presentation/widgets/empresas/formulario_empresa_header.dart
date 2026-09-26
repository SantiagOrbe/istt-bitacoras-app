import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class FormularioEmpresaHeader extends StatelessWidget {
  final bool isEditing;

  const FormularioEmpresaHeader({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColores.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
              ),
              child: Icon(
                isEditing ? Icons.edit_note_rounded : Icons.domain_add_rounded,
                color: AppColores.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEditing ? 'Editar Empresa' : 'Registrar Nueva Empresa',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColores.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}