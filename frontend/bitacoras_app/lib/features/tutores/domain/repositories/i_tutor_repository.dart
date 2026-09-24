import 'package:bitacoras_app/features/tutores/tutores.dart';


abstract class ITutorRepository {
  Future<List<EstudianteAsignadoModel>> getAssignedStudents(String tutorId, {required bool isAcademic});
  Future<List<RegistroPracticaModel>> getStudentLogs(String studentId, {bool isAcademic = true});
  Future<EstadoVisitaTutorModel> getTodayVisitStatus();
  Future<EstadoVisitaTutorModel> registerTutorEntry({required double latitude, required double longitude});
  Future<EstadoVisitaTutorModel> registerTutorExit({required double latitude, required double longitude});
  Future<EstadoVisitaTutorModel> updateTutorActivities({required String visitId, required String activities});
  Future<List<Map<String, dynamic>>> getTutorVisitHistory();
  Future<Uint8List> downloadTutorReportPdf();
  Future<RegistroPracticaModel> updateLog({
    required String logId,
    String? activityDescription,
    bool? isActive,
  });
}