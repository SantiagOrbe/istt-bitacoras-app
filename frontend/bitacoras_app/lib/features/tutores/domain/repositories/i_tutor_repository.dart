import 'package:bitacoras_app/features/tutores/tutores.dart';


abstract class ITutorRepository {
  Future<List<EstudianteAsignadoModel>> getAssignedStudents(String tutorId, {required bool isAcademic});
  Future<List<EstudianteAsignadoModel>> obtenerEstudiantesAsignados(String tutorId, {required bool esAcademico});

  Future<List<RegistroPracticaModel>> getStudentLogs(String studentId, {bool isAcademic = true});
  Future<List<RegistroPracticaModel>> obtenerRegistrosEstudiante(String studentId, {bool esAcademico = true});

  Future<EstadoVisitaTutorModel> getTodayVisitStatus();
  Future<EstadoVisitaTutorModel> obtenerEstadoVisitaDeHoy();

  Future<EstadoVisitaTutorModel> registerTutorEntry({required double latitude, required double longitude});
  Future<EstadoVisitaTutorModel> registrarEntradaTutor({required double latitude, required double longitude});

  Future<EstadoVisitaTutorModel> registerTutorExit({required double latitude, required double longitude});
  Future<EstadoVisitaTutorModel> registrarSalidaTutor({required double latitude, required double longitude});

  Future<EstadoVisitaTutorModel> updateTutorActivities({required String visitId, required String activities});
  Future<EstadoVisitaTutorModel> actualizarActividadesTutor({required String visitaId, required String actividades});

  Future<List<Map<String, dynamic>>> getTutorVisitHistory();
  Future<List<Map<String, dynamic>>> obtenerHistorialVisitasTutor();

  Future<Uint8List> downloadTutorReportPdf();
  Future<Uint8List> descargarReportePdfTutor();

  Future<RegistroPracticaModel> updateLog({
    required String logId,
    String? activityDescription,
    bool? isActive,
  });
  Future<RegistroPracticaModel> actualizarRegistro({
    required String registroId,
    String? descripcionActividad,
    bool? activo,
  });
}