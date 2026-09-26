import 'package:bitacoras_app/features/tutores/tutores.dart';

class TutorRemoteDataSource {
  final ApiClient apiClient;

  TutorRemoteDataSource({required this.apiClient});

  Future<dynamic> getAssignedStudents({required bool isAcademic}) {
    return obtenerEstudiantesAsignados(esAcademico: isAcademic);
  }

  Future<dynamic> obtenerEstudiantesAsignados({required bool esAcademico}) {
    return apiClient.get(
      esAcademico
          ? 'usuarios/tutor-academico/mis-tutoriados/'
          : 'usuarios/tutor-empresarial/mis-pasantes/',
    );
  }

  Future<dynamic> getStudentLogs({required bool isAcademic}) {
    return obtenerRegistrosEstudiante(esAcademico: isAcademic);
  }

  Future<dynamic> obtenerRegistrosEstudiante({required bool esAcademico}) {
    return apiClient.get(
      esAcademico
          ? 'usuarios/tutor-academico/mis-tutoriados/'
          : 'usuarios/tutor-empresarial/mis-pasantes/',
    );
  }

  Future<Map<String, dynamic>> getTodayVisitStatus() {
    return obtenerEstadoVisitaDeHoy();
  }

  Future<Map<String, dynamic>> obtenerEstadoVisitaDeHoy() async {
    final response = await apiClient.get('bitacoras/visitas-tutor/estado-hoy/');
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del estado de visita no es válida.');
    }
    return response;
  }

  Future<Map<String, dynamic>> registerTutorEntry({
    required double latitude,
    required double longitude,
  }) {
    return registrarEntradaTutor(latitude: latitude, longitude: longitude);
  }

  Future<Map<String, dynamic>> registrarEntradaTutor({
    required double latitude,
    required double longitude,
  }) async {
    final response = await apiClient.post(
      'bitacoras/visitas-tutor/entrada/',
      body: {'latitud': latitude, 'longitud': longitude},
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de entrada no es válida.');
    }
    return response;
  }

  Future<Map<String, dynamic>> registerTutorExit({
    required double latitude,
    required double longitude,
  }) {
    return registrarSalidaTutor(latitude: latitude, longitude: longitude);
  }

  Future<Map<String, dynamic>> registrarSalidaTutor({
    required double latitude,
    required double longitude,
  }) async {
    final response = await apiClient.post(
      'bitacoras/visitas-tutor/salida/',
      body: {'latitud': latitude, 'longitud': longitude},
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de salida no es válida.');
    }
    return response;
  }

  Future<Map<String, dynamic>> updateTutorActivities({
    required String visitId,
    required String activities,
  }) {
    return actualizarActividadesTutor(
      visitaId: visitId,
      actividades: activities,
    );
  }

  Future<Map<String, dynamic>> actualizarActividadesTutor({
    required String visitaId,
    required String actividades,
  }) async {
    final response = await apiClient.patch(
      'bitacoras/visitas-tutor/$visitaId/',
      body: {'actividades': actividades},
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de actividades no es válida.');
    }
    return response;
  }

  Future<dynamic> getTutorVisitHistory() {
    return obtenerHistorialVisitasTutor();
  }

  Future<dynamic> obtenerHistorialVisitasTutor() {
    return apiClient.get('bitacoras/visitas-tutor/');
  }

  Future<Uint8List> downloadTutorReportPdf() {
    return descargarReportePdfTutor();
  }

  Future<Uint8List> descargarReportePdfTutor() {
    return apiClient.downloadBinary('bitacoras/visitas-tutor/mi-reporte-pdf/');
  }

  Future<Map<String, dynamic>> updateLog({
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

  Future<Map<String, dynamic>> actualizarRegistro({
    required String registroId,
    String? descripcionActividad,
    bool? activo,
  }) async {
    final body = <String, dynamic>{};
    if (descripcionActividad != null) {
      body['actividad_descripcion'] = descripcionActividad;
    }
    if (activo != null) {
      body['estado'] = activo;
    }
    if (body.isEmpty) {
      throw ArgumentError('Debe enviarse al menos un campo para actualizar el registro.');
    }

    final response = await apiClient.patch('bitacoras/registros/$registroId/', body: body);
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del registro no es válida.');
    }
    return response;
  }
}