import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';

class AsignacionEstudianteDropdowns extends StatelessWidget {
  final String? academicTutorId;
  final String? companyId;
  final String? companyTutorId;
  final ValueChanged<String?> onAcademicTutorChanged;
  final ValueChanged<String?> onCompanyChanged;
  final ValueChanged<String?> onCompanyTutorChanged;

  const AsignacionEstudianteDropdowns({
    super.key,
    required this.academicTutorId,
    required this.companyId,
    required this.companyTutorId,
    required this.onAcademicTutorChanged,
    required this.onCompanyChanged,
    required this.onCompanyTutorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final academicTutors = [
      {'id': 'tut-acad-01', 'name': 'Ing. Fernando Pérez'},
      {'id': 'tut-acad-02', 'name': 'Ing. Patricia Gómez'},
    ];
    final companies = [
      {'id': '1', 'name': 'GAD Municipal de Tena'},
      {'id': '2', 'name': 'Ministerio de Educación'},
      {'id': '3', 'name': 'Empresa Eléctrica Ambato SA'},
    ];
    final companyTutors = [
      {'id': 'tut-emp-01', 'name': 'Ing. Carlos Mendoza'},
      {'id': 'tut-emp-02', 'name': 'Leda. María Ramos'},
    ];

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
            _dropdown('Tutor Empresarial', companyTutorId, companyTutors, onCompanyTutorChanged, Icons.badge_outlined),
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