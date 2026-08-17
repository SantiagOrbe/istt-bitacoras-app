import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';

class FormularioEmpresaHeader extends StatelessWidget {
  final bool isEditing;

  const FormularioEmpresaHeader({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}