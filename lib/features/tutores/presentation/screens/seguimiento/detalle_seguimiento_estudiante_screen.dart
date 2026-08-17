import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../data/repositories/fake_tutor_repository.dart';
import '../../../domain/models/estudiante_asignado_model.dart';
import '../../../domain/repositories/i_tutor_repository.dart';

class DetalleSeguimientoEstudianteScreen extends StatefulWidget {
  final EstudianteAsignadoModel assignedStudent;

  const DetalleSeguimientoEstudianteScreen({super.key, required this.assignedStudent});

  @override
  State<DetalleSeguimientoEstudianteScreen> createState() => _DetalleSeguimientoEstudianteScreenState();
}

class _DetalleSeguimientoEstudianteScreenState extends State<DetalleSeguimientoEstudianteScreen> {
  final ITutorRepository _repository = FakeTutorRepository();
  List<RegistroPracticaModel> _logs = [];
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
    final item = widget.assignedStudent;
    final student = item.student;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detalle: ${student.name}'),
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
                    Text(student.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Empresa: ${student.company ?? "N/A"}'),
                    Text('Tutor Empresarial: ${item.companyTutorName} (${item.companyTutorPhone})'),
                    Text('Horas Acumuladas: ${item.totalHoursCompleted} / ${item.totalHoursRequired} hrs'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: item.progressPercentage, backgroundColor: AppColors.divider, color: AppColors.primary, minHeight: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Historial de Bitácoras / Actividades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text('${log.date} (${log.entryTime} - ${log.exitTime ?? "En curso"})'),
                          subtitle: Text(log.activityDescription),
                          trailing: Chip(
                            label: Text(log.status, style: const TextStyle(color: Colors.white, fontSize: 10)),
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