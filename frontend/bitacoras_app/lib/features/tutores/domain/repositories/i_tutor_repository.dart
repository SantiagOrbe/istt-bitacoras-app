import 'dart:typed_data';

import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:bitacoras_app/features/tutores/domain/models/visita_academica_model.dart';

import '../models/estudiante_asignado_model.dart';
import '../models/estado_visita_tutor_model.dart';

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
  Future<bool> saveAcademicVisit(VisitaAcademicaModel visit);
  Future<List<VisitaAcademicaModel>> getAcademicVisits(String tutorId);
}