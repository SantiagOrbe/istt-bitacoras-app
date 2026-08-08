import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/practice_log_model.dart';
import '../../data/repositories/fake_tutor_repository.dart';
import '../../domain/models/assigned_student_model.dart';
import '../../domain/repositories/i_tutor_repository.dart';

class StudentTutorDetailScreen extends StatefulWidget {
  final AssignedStudentModel assignedStudent;
  final UserModel currentUser;

  const StudentTutorDetailScreen({
    super.key,
    required this.assignedStudent,
    required this.currentUser,
  });

  @override
  State<StudentTutorDetailScreen> createState() => _StudentTutorDetailScreenState();
}

class _StudentTutorDetailScreenState extends State<StudentTutorDetailScreen> {
  final ITutorRepository _repository = FakeTutorRepository();
  List<PracticeLogModel> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    final logs = await _repository.getStudentLogs(widget.assignedStudent.student.id);
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.assignedStudent.student;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detalle de ${student.name}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Cédula: ${student.cedula ?? 'N/A'}'),
                    Text('Email: ${student.email}'),
                    Text('Empresa: ${student.company ?? 'N/A'}'),
                    Text('Carrera: ${student.careerName ?? 'N/A'}'),
                    Text('Periodo: ${student.periodName ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bitácoras Registradas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _logs.isEmpty
                    ? const Center(child: Text('El estudiante aún no tiene bitácoras registradas.'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              title: Text('${log.date} - ${log.entryTime} a ${log.exitTime ?? "En curso"}'),
                              subtitle: Text(log.activityDescription),
                              trailing: Chip(
                                label: Text(
                                  log.status,
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                                backgroundColor: log.status == 'Aprobado' ? AppColors.success : Colors.orange,
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}