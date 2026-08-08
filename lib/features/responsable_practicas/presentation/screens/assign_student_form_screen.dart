import 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/assign_student_form_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../home/data/repositories/fake_user_repository.dart';
import '../../../home/presentation/widgets/home_app_bar.dart';
import '../../domain/models/student_assignment_model.dart';
import '../controllers/student_assignment_controller.dart';

class AssignStudentFormScreen extends StatelessWidget {
  final StudentAssignmentModel assignment;
  final StudentAssignmentController controller;

  const AssignStudentFormScreen({
    super.key,
    required this.assignment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        user: FakeUserRepository.practiceManager,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AssignStudentFormBody(assignment: assignment, controller: controller),
      ),
    );
  }
}