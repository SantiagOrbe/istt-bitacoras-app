import 'package:bitacoras_app/features/admin/domain/models/practice_log_model.dart';
import 'package:bitacoras_app/features/tutores/domain/models/academic_visit_model.dart';

import '../models/assigned_student_model.dart';

abstract class ITutorRepository {
  Future<List<AssignedStudentModel>> getAssignedStudents(String tutorId, {required bool isAcademic});
  Future<List<PracticeLogModel>> getStudentLogs(String studentId);
  Future<bool> saveAcademicVisit(AcademicVisitModel visit);
  Future<List<AcademicVisitModel>> getAcademicVisits(String tutorId);
}