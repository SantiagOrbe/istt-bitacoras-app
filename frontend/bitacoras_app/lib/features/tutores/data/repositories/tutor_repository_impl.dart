import 'package:bitacoras_app/features/tutores/tutores.dart';


class TutorRepositoryImpl implements ITutorRepository {
  final TutorRemoteDataSource remoteDataSource;

  TutorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<EstudianteAsignadoModel>> getAssignedStudents(
    String tutorId, {
    required bool isAcademic,
  }) async {
    final response = await remoteDataSource.getAssignedStudents(
      isAcademic: isAcademic,
    );
    final students = _extractList(response, 'estudiantes');
    return students
        .whereType<Map<String, dynamic>>()
        .map(EstudianteAsignadoModel.fromJson)
        .toList();
  }

  @override
  Future<List<RegistroPracticaModel>> getStudentLogs(
    String studentId, {
    bool isAcademic = true,
  }) async {
    final response = await remoteDataSource.getStudentLogs(
      isAcademic: isAcademic,
    );
    final logs = _extractList(response, 'registros');
    return logs
        .whereType<Map<String, dynamic>>()
        .where(
          (log) =>
              (log['student_id'] ?? log['studentId'])?.toString() == studentId,
        )
        .map(RegistroPracticaModel.fromJson)
        .toList();
  }

  @override
  Future<EstadoVisitaTutorModel> getTodayVisitStatus() async {
    final response = await remoteDataSource.getTodayVisitStatus();
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> registerTutorEntry({
    required double latitude,
    required double longitude,
  }) async {
    final response = await remoteDataSource.registerTutorEntry(
      latitude: latitude,
      longitude: longitude,
    );
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> registerTutorExit({
    required double latitude,
    required double longitude,
  }) async {
    final response = await remoteDataSource.registerTutorExit(
      latitude: latitude,
      longitude: longitude,
    );
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> updateTutorActivities({
    required String visitId,
    required String activities,
  }) async {
    final response = await remoteDataSource.updateTutorActivities(
      visitId: visitId,
      activities: activities,
    );
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getTutorVisitHistory() async {
    final response = await remoteDataSource.getTutorVisitHistory();
    final records = response is List
        ? response
        : response is Map<String, dynamic>
        ? response['results']
        : null;
    if (records is! List) {
      throw const FormatException('La respuesta del historial no es válida.');
    }
    return records.whereType<Map<String, dynamic>>().toList();
  }

  @override
  Future<Uint8List> downloadTutorReportPdf() {
    return remoteDataSource.downloadTutorReportPdf();
  }

  @override
  Future<RegistroPracticaModel> updateLog({
    required String logId,
    String? activityDescription,
    bool? isActive,
  }) async {
    final response = await remoteDataSource.updateLog(
      logId: logId,
      activityDescription: activityDescription,
      isActive: isActive,
    );
    return RegistroPracticaModel.fromJson(response);
  }

  List<dynamic> _extractList(dynamic response, String key) {
    final values = response is List
        ? response
        : response is Map<String, dynamic>
        ? response[key]
        : null;
    if (values is! List) {
      throw FormatException('La respuesta no contiene una lista válida: $key.');
    }
    return values;
  }
}