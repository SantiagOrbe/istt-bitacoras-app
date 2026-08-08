import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/apps.dart';
import '../../../../config/constants/app_colors.dart';
import '../../domain/models/student_assignment_model.dart';
import '../controllers/student_assignment_controller.dart';

class StudentAssignmentCard extends StatelessWidget {
  final StudentAssignmentModel assignment;
  final StudentAssignmentController controller;

  const StudentAssignmentCard({
    super.key,
    required this.assignment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isAssigned = assignment.isAssigned;

    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  assignment.studentName,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAssigned ? AppColors.successSoft : AppColors.warningSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAssigned ? 'Asignado' : 'Pendiente',
                    style: TextStyle(
                      fontSize: 11,
                      color: isAssigned ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Cédula: ${assignment.studentIdentification}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            if (isAssigned) ...[
              const Divider(color: AppColors.divider),
              Text('Empresa: ${assignment.companyName}', style: const TextStyle(fontSize: 13)),
              Text('Tutor Académico: ${assignment.academicTutorName}', style: const TextStyle(fontSize: 13)),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(
                    AppRoutes.responsablePracticasAssignStudentForm,
                    extra: {'assignment': assignment, 'controller': controller},
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                icon: Icon(isAssigned ? Icons.edit_rounded : Icons.add_link_rounded, color: AppColors.surface, size: 18),
                label: Text(
                  isAssigned ? 'Reasignar Tutores' : 'Asignar Tutores',
                  style: const TextStyle(color: AppColors.surface),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}