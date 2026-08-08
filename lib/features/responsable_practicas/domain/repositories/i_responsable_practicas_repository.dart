import 'package:bitacoras_app/features/home/domain/models/quick_action.dart';

import '../models/company_model.dart';
import '../models/student_assignment_model.dart';

abstract class IResponsablePracticasRepository {
  List<QuickAction> responsablePracticasActions();

  // Gestión de Empresas (CRUD)
  Future<List<CompanyModel>> getCompanies({String? query});
  Future<CompanyModel?> getCompanyById(String id);
  Future<bool> saveCompany(CompanyModel company);
  Future<bool> toggleCompanyActiveStatus(String id, bool isActive);

  // Gestión de Asignaciones
  Future<List<StudentAssignmentModel>> getStudentAssignments({String? query, bool? pendingOnly});
  Future<bool> assignStudent({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  });
}