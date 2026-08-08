import 'package:bitacoras_app/features/tutores/domain/models/assigned_student_model.dart';
import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';

class VisitHeaderCard extends StatelessWidget {
  final AssignedStudentModel studentData;

  const VisitHeaderCard({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    final s = studentData.student;
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.company ?? 'Empresa no asignada',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _infoRow(Icons.person, 'Estudiante:', s.name),
            _infoRow(Icons.school, 'Carrera:', s.careerName ?? 'Software'),
            _infoRow(Icons.badge, 'Tutor Empresarial:', studentData.companyTutorName),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(width: 6),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}