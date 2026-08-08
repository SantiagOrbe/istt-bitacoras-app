import 'package:flutter/material.dart';
import '../../../../config/constants/app_colors.dart';
import '../controllers/student_assignment_controller.dart';
import 'student_assignment_card.dart';

class StudentAssignmentsBody extends StatelessWidget {
  final StudentAssignmentController controller;

  const StudentAssignmentsBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: controller.searchAssignments,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Buscar por estudiante o cédula...',
              hintStyle: const TextStyle(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView.builder(
                  itemCount: controller.assignments.length,
                  itemBuilder: (context, index) {
                    return StudentAssignmentCard(
                      assignment: controller.assignments[index],
                      controller: controller,
                    );
                  },
                ),
        ),
      ],
    );
  }
}