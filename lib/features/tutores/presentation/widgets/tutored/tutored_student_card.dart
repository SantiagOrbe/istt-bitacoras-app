import 'package:bitacoras_app/features/tutores/domain/models/assigned_student_model.dart';
import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';

class TutoredStudentCard extends StatelessWidget {
  final AssignedStudentModel item;
  final VoidCallback onTap;

  const TutoredStudentCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final student = item.student;

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(student.initials, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                        Text(student.careerName ?? 'Sin carrera', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(item.status, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Empresa: ${student.company ?? 'N/A'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('${item.totalHoursCompleted}/${item.totalHoursRequired} hrs', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: item.progressPercentage, backgroundColor: AppColors.divider, color: AppColors.primary, minHeight: 6),
            ],
          ),
        ),
      ),
    );
  }
}