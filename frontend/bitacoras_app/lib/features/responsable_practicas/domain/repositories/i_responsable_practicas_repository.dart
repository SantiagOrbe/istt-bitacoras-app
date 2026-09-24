import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


abstract class IResponsablePracticasRepository {
  void invalidateCache();

  List<AccionRapidaModel> responsablePracticasActions();

  // Gestión de Empresas (CRUD)
  Future<List<EmpresaModel>> getCompanies({String? query});
  Future<EmpresaModel?> getCompanyById(String id);
  Future<bool> saveCompany(EmpresaModel company);
  Future<bool> toggleCompanyActiveStatus(String id, bool isActive);

  // Gestión de Asignaciones
  Future<List<AsignacionEstudianteModel>> getStudentAssignments({String? query, bool? pendingOnly});
  Future<bool> assignStudent({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  });

  Future<Map<String, List<Map<String, String>>>> getAssignmentOptions();
  Future<Map<String, List<Map<String, String>>>> getAcademicHierarchy();
}