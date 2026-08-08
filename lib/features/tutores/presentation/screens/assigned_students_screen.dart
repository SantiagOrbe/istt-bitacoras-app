import 'package:bitacoras_app/features/home/domain/models/user_model.dart';
import 'package:bitacoras_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:bitacoras_app/features/tutores/data/repositories/fake_tutor_repository.dart';
import 'package:bitacoras_app/features/tutores/presentation/screens/student_detail_tracking_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';

import '../../domain/models/assigned_student_model.dart';
import '../../domain/repositories/i_tutor_repository.dart';
import '../widgets/tutored/tutored_student_card.dart';

class AssignedStudentsScreen extends StatefulWidget {
  final UserModel currentUser;
  final bool isAcademic;

  const AssignedStudentsScreen({super.key, required this.currentUser, required this.isAcademic});

  @override
  State<AssignedStudentsScreen> createState() => _AssignedStudentsScreenState();
}

class _AssignedStudentsScreenState extends State<AssignedStudentsScreen> {
  final ITutorRepository _repository = FakeTutorRepository();
  List<AssignedStudentModel> _assignedList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _repository.getAssignedStudents(widget.currentUser.id, isAcademic: widget.isAcademic);
    setState(() {
      _assignedList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(user: widget.currentUser),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.isAcademic ? 'Mis Tutoriados' : 'Pasantes en Empresa', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _assignedList.isEmpty
                      ? const Center(child: Text('No hay estudiantes asignados.'))
                      : ListView.builder(
                          itemCount: _assignedList.length,
                          itemBuilder: (context, index) {
                            final item = _assignedList[index];
                            return TutoredStudentCard(
                              item: item,
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentDetailTrackingScreen(assignedStudent: item))),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}