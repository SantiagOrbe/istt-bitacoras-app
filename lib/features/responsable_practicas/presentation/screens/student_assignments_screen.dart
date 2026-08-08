import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../home/data/repositories/fake_user_repository.dart';
import '../../../home/presentation/widgets/home_app_bar.dart';
import '../../data/repositories/fake_responsable_practicas_repository.dart';
import '../controllers/student_assignment_controller.dart';
import '../widgets/student_assignments_body.dart';

class StudentAssignmentsScreen extends StatefulWidget {
  const StudentAssignmentsScreen({super.key});

  @override
  State<StudentAssignmentsScreen> createState() => _StudentAssignmentsScreenState();
}

class _StudentAssignmentsScreenState extends State<StudentAssignmentsScreen> {
  late final StudentAssignmentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StudentAssignmentController(
      repository: FakeResponsablePracticasRepository(),
    );
    _controller.loadAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(
            user: FakeUserRepository.practiceManager,
            showBackButton: true,
            showDrawerButton: false,
            onBackPressed: () => context.pop(),
          ),
          body: StudentAssignmentsBody(controller: _controller),
        );
      },
    );
  }
}