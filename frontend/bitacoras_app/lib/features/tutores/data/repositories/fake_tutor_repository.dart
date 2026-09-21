import 'package:bitacoras_app/core/network/api_client.dart';
import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/visita_academica_model.dart';
import '../../domain/models/estudiante_asignado_model.dart';
import '../../domain/models/estado_visita_tutor_model.dart';
import '../../domain/repositories/i_tutor_repository.dart';

class FakeTutorRepository implements ITutorRepository {
  final ApiClient _apiClient;
  final List<VisitaAcademicaModel> _mockVisits = [];

  FakeTutorRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<EstudianteAsignadoModel>> getAssignedStudents(
    String tutorId, {
    required bool isAcademic,
  }) async {
    if (!isAcademic) return [];

    try {
      final response = await _apiClient.get('usuarios/tutor-academico/mis-tutoriados/');
      debugPrint('=== DEBUG TUTOR LIST ===');
      debugPrint('tutorId: $tutorId');
      debugPrint('isAcademic: $isAcademic');
      debugPrint('response: $response');

      final rawStudents = switch (response) {
        Map<String, dynamic> map => map['estudiantes'] ?? map['students'] ?? const <dynamic>[],
        List list => list,
        _ => const <dynamic>[],
      };

      final students = rawStudents is List ? rawStudents : const <dynamic>[];
      debugPrint('rawStudents length: ${students.length}');

      final parsed = <EstudianteAsignadoModel>[];
      for (var i = 0; i < students.length; i++) {
        final item = students[i];
        if (item is! Map<String, dynamic>) {
          debugPrint('item $i is not Map<String, dynamic>: ${item.runtimeType}');
          continue;
        }

        try {
          final model = EstudianteAsignadoModel.fromJson(item);
          parsed.add(model);
          debugPrint('parsed item $i ok: ${model.student.name}');
        } catch (error, stackTrace) {
          debugPrint('FAILED to parse item $i: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      }

      debugPrint('parsed students length: ${parsed.length}');
      return parsed;
    } on ApiException catch (e) {
      debugPrint('=== DEBUG TUTOR LIST ERROR ===');
      debugPrint('status: ${e.statusCode}');
      debugPrint('message: ${e.message}');
      debugPrint('body: ${e.body}');
      return const [];
    }
  }

  @override
  Future<List<RegistroPracticaModel>> getStudentLogs(String studentId) async {
    try {
      final response = await _apiClient.get('usuarios/tutor-academico/mis-tutoriados/');
      final logs = response is Map<String, dynamic>
          ? (response['registros'] as List? ?? const [])
          : const <dynamic>[];

      return logs
          .whereType<Map<String, dynamic>>()
          .where((log) => (log['student_id'] ?? log['studentId'])?.toString() == studentId)
          .map((log) => RegistroPracticaModel.fromJson(log))
          .toList();
    } on ApiException {
      return const [];
    }
  }

  @override
  Future<EstadoVisitaTutorModel> getTodayVisitStatus() async {
    final response = await _apiClient.get('bitacoras/visitas-tutor/estado-hoy/');
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del estado de visita no es válida.');
    }
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> registerTutorEntry({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiClient.post(
      'bitacoras/visitas-tutor/entrada/',
      body: {'latitud': latitude, 'longitud': longitude},
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de entrada no es válida.');
    }
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> registerTutorExit({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiClient.post(
      'bitacoras/visitas-tutor/salida/',
      body: {'latitud': latitude, 'longitud': longitude},
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de salida no es válida.');
    }
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<EstadoVisitaTutorModel> updateTutorActivities({
    required String visitId,
    required String activities,
  }) async {
    final response = await _apiClient.patch(
      'bitacoras/visitas-tutor/$visitId/',
      body: {'actividades': activities},
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de actividades no es válida.');
    }
    return EstadoVisitaTutorModel.fromJson(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getTutorVisitHistory() async {
    final response = await _apiClient.get('bitacoras/visitas-tutor/');
    final records = response is List
        ? response
        : response is Map<String, dynamic>
            ? response['results']
            : null;
    if (records is! List) return const [];
    return records.whereType<Map<String, dynamic>>().toList();
  }

  @override
  Future<RegistroPracticaModel> updateLog({
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

    final response = await _apiClient.patch('bitacoras/registros/$logId/', body: body);
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del registro no es válida.');
    }

    return RegistroPracticaModel.fromJson(response);
  }

  @override
  Future<bool> saveAcademicVisit(VisitaAcademicaModel visit) async {
    _mockVisits.add(visit);
    return true;
  }

  @override
  Future<List<VisitaAcademicaModel>> getAcademicVisits(String tutorId) async {
    return List.of(_mockVisits);
  }
}