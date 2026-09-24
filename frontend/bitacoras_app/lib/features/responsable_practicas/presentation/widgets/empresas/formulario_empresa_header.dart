import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class FormularioEmpresaHeader extends StatelessWidget {
  final bool isEditing;

  const FormularioEmpresaHeader({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                isEditing ? Icons.edit_note_rounded : Icons.domain_add_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEditing ? 'Editar Empresa' : 'Registrar Nueva Empresa',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}