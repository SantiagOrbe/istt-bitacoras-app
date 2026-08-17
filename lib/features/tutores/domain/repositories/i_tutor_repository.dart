import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:bitacoras_app/features/tutores/domain/models/visita_academica_model.dart';

import '../models/estudiante_asignado_model.dart';

abstract class ITutorRepository {
  Future<List<EstudianteAsignadoModel>> getAssignedStudents(String tutorId, {required bool isAcademic});
  Future<List<RegistroPracticaModel>> getStudentLogs(String studentId);
  Future<bool> saveAcademicVisit(VisitaAcademicaModel visit);
  Future<List<VisitaAcademicaModel>> getAcademicVisits(String tutorId);
}