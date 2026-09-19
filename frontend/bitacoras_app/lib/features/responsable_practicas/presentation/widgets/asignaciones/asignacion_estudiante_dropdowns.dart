import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';

class AsignacionEstudianteDropdowns extends StatelessWidget {
  final String? academicTutorId;
  final String? companyId;
  final String? companyTutorId;
  final ValueChanged<String?> onAcademicTutorChanged;
  final ValueChanged<String?> onCompanyChanged;
  final ValueChanged<String?> onCompanyTutorChanged;
  final List<Map<String, String>> academicTutors;
  final List<Map<String, String>> companies;
  final List<Map<String, String>> companyTutors;

  const AsignacionEstudianteDropdowns({
    super.key,
    required this.academicTutorId,
    required this.companyId,
    required this.companyTutorId,
    required this.onAcademicTutorChanged,
    required this.onCompanyChanged,
    required this.onCompanyTutorChanged,
    required this.academicTutors,
    required this.companies,
    required this.companyTutors,
  });

  @override
  Widget build(BuildContext context) {
    final availableCompanyTutors = companyTutors
        .where((tutor) => tutor['companyId'] == companyId)
        .toList();
    final selectedCompanyTutorId = availableCompanyTutors.any(
      (tutor) => tutor['id'] == companyTutorId,
    )
        ? companyTutorId
        : null;

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _dropdown('Tutor Académico', academicTutorId, academicTutors, onAcademicTutorChanged, Icons.school_outlined),
            const SizedBox(height: 16),
            _dropdown('Empresa Receptora', companyId, companies, onCompanyChanged, Icons.business_outlined),
            const SizedBox(height: 16),
            _dropdown(
              'Tutor Empresarial',
              selectedCompanyTutorId,
              availableCompanyTutors,
              onCompanyTutorChanged,
              Icons.badge_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String label, String? value, List<Map<String, String>> items, ValueChanged<String?> onChanged, IconData icon) {
    return DropdownButtonFormField<String>(
      isExpanded: true, // 👈 SOLUCIÓN 1: Obliga al Dropdown a adaptarse al ancho horizontal disponible
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items
          .map(
            (i) => DropdownMenuItem(
              value: i['id'],
              child: Text(
                i['name']!,
                overflow: TextOverflow.ellipsis, // 👈 SOLUCIÓN 2: Trunca texto largo con '...'
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Seleccione una opción' : null,
    );
  }
}