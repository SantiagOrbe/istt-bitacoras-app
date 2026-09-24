import 'package:bitacoras_app/features/tutores/tutores.dart';

class TutorRemoteDataSource {
  final ApiClient apiClient;

  TutorRemoteDataSource({required this.apiClient});

  Future<dynamic> getAssignedStudents({required bool isAcademic}) {
    return apiClient.get(
      isAcademic
          ? 'usuarios/tutor-academico/mis-tutoriados/'
          : 'usuarios/tutor-empresarial/mis-pasantes/',
    );
  }

  Future<dynamic> getStudentLogs({required bool isAcademic}) {
    return apiClient.get(
      isAcademic
          ? 'usuarios/tutor-academico/mis-tutoriados/'
          : 'usuarios/tutor-empresarial/mis-pasantes/',
    );
  }

  Future<Map<String, dynamic>> getTodayVisitStatus() async {
    final response = await apiClient.get('bitacoras/visitas-tutor/estado-hoy/');
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del estado de visita no es válida.');
    }
    return response;
  }

  Future<Map<String, dynamic>> registerTutorEntry({
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
  }) async {
    final response = await apiClient.patch(
      'bitacoras/visitas-tutor/$visitId/',
      body: {'actividades': activities},
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de actividades no es válida.');
    }
    return response;
  }

  Future<dynamic> getTutorVisitHistory() {
    return apiClient.get('bitacoras/visitas-tutor/');
  }

  Future<Uint8List> downloadTutorReportPdf() {
    return apiClient.downloadBinary('bitacoras/visitas-tutor/mi-reporte-pdf/');
  }

  Future<Map<String, dynamic>> updateLog({
    required String logId,
    String? activityDescription,
    bool? isActive,
  }) async {
    final body = <String, dynamic>{};
    if (activityDescription != null) {
      body['actividad_descripcion'] = activityDescription;
    }
    if (isActive != null) {
      body['estado'] = isActive;
    }
    if (body.isEmpty) {
      throw ArgumentError('Debe enviarse al menos un campo para actualizar el registro.');
    }

    final response = await apiClient.patch('bitacoras/registros/$logId/', body: body);
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del registro no es válida.');
    }
    return response;
  }
}