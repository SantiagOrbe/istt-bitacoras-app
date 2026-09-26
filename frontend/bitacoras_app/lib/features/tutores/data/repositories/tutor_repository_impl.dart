import 'package:bitacoras_app/features/tutores/tutores.dart';


class TutorRepositoryImpl implements ITutorRepository {
  final TutorRemoteDataSource remoteDataSource;

  TutorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<EstudianteAsignadoModel>> getAssignedStudents(
    String tutorId, {
    required bool isAcademic,
  }) {
    return obtenerEstudiantesAsignados(
      tutorId,
      esAcademico: isAcademic,
    );
  }

  Future<List<EstudianteAsignadoModel>> obtenerEstudiantesAsignados(
    String tutorId, {
    required bool esAcademico,
  }) async {
    final response = await remoteDataSource.obtenerEstudiantesAsignados(
      esAcademico: esAcademico,
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
  }) {
    return obtenerRegistrosEstudiante(
      studentId,
      esAcademico: isAcademic,
    );
  }

  Future<List<RegistroPracticaModel>> obtenerRegistrosEstudiante(
    String studentId, {
    bool esAcademico = true,
  }) async {
    final response = await remoteDataSource.obtenerRegistrosEstudiante(
      esAcademico: esAcademico,
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
  Future<EstadoVisitaTutorModel> getTodayVisitStatus() {
    return obtenerEstadoVisitaDeHoy();
  }

  Future<EstadoVisitaTutorModel> obtenerEstadoVisitaDeHoy() async {
    final response = await remoteDataSource.obtenerEstadoVisitaDeHoy();
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> registerTutorEntry({
    required double latitude,
    required double longitude,
  }) {
    return registrarEntradaTutor(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<EstadoVisitaTutorModel> registrarEntradaTutor({
    required double latitude,
    required double longitude,
  }) async {
    final response = await remoteDataSource.registrarEntradaTutor(
      latitude: latitude,
      longitude: longitude,
    );
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> registerTutorExit({
    required double latitude,
    required double longitude,
  }) {
    return registrarSalidaTutor(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<EstadoVisitaTutorModel> registrarSalidaTutor({
    required double latitude,
    required double longitude,
  }) async {
    final response = await remoteDataSource.registrarSalidaTutor(
      latitude: latitude,
      longitude: longitude,
    );
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> updateTutorActivities({
    required String visitId,
    required String activities,
  }) {
    return actualizarActividadesTutor(
      visitaId: visitId,
      actividades: activities,
    );
  }

  Future<EstadoVisitaTutorModel> actualizarActividadesTutor({
    required String visitaId,
    required String actividades,
  }) async {
    final response = await remoteDataSource.actualizarActividadesTutor(
      visitaId: visitaId,
      actividades: actividades,
    );
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getTutorVisitHistory() {
    return obtenerHistorialVisitasTutor();
  }

  Future<List<Map<String, dynamic>>> obtenerHistorialVisitasTutor() async {
    final response = await remoteDataSource.obtenerHistorialVisitasTutor();
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
    return descargarReportePdfTutor();
  }

  Future<Uint8List> descargarReportePdfTutor() {
    return remoteDataSource.descargarReportePdfTutor();
  }

  @override
  Future<RegistroPracticaModel> updateLog({
    required String logId,
    String? activityDescription,
    bool? isActive,
  }) {
    return actualizarRegistro(
      registroId: logId,
      descripcionActividad: activityDescription,
      activo: isActive,
    );
  }

  Future<RegistroPracticaModel> actualizarRegistro({
    required String registroId,
    String? descripcionActividad,
    bool? activo,
  }) async {
    final response = await remoteDataSource.actualizarRegistro(
      registroId: registroId,
      descripcionActividad: descripcionActividad,
      activo: activo,
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