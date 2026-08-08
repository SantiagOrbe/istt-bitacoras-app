import 'package:bitacoras_app/features/tutores/domain/models/assigned_student_model.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/app_colors.dart';

class StudentTrackingCard extends StatelessWidget {
  final AssignedStudentModel item;
  final VoidCallback onTap;

  const StudentTrackingCard({
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${(item.progressPercentage * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 4),
              Text('Completadas: ${item.totalHoursCompleted} hrs | Restantes: ${item.remainingHours} hrs', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: item.progressPercentage, backgroundColor: AppColors.divider, color: AppColors.primary, minHeight: 6),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('Última asistencia: ${item.lastAttendanceTime ?? "Sin registro"}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.event_note, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Última actividad: ${item.lastActivityDescription ?? "Sin actividad"}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}