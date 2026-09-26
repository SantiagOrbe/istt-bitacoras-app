import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

abstract class IResponsablePracticasRepository {
  void invalidarCache();

  List<AccionRapidaModel> accionesResponsablePracticas();

  // Gestión de Empresas (CRUD)
  Future<List<EmpresaModel>> obtenerEmpresas({String? query});
  Future<EmpresaModel?> obtenerEmpresaPorId(String id);
  Future<bool> guardarEmpresa(EmpresaModel empresa);
  Future<bool> alternarEstadoEmpresa(String id, bool estaActivo);

  // Gestión de Asignaciones
  Future<List<AsignacionEstudianteModel>> obtenerAsignacionesEstudiante({String? query, bool? pendingOnly});
  Future<bool> asignarEstudiante({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  });

  Future<Map<String, List<Map<String, String>>>> obtenerOpcionesAsignacion();
  Future<Map<String, List<Map<String, String>>>> obtenerJerarquiaAcademica();

  // Alias de compatibilidad con la nomenclatura anterior.
  void invalidateCache() => invalidarCache();
  List<AccionRapidaModel> responsablePracticasActions() => accionesResponsablePracticas();
  Future<List<EmpresaModel>> getCompanies({String? query}) => obtenerEmpresas(query: query);
  Future<EmpresaModel?> getCompanyById(String id) => obtenerEmpresaPorId(id);
  Future<bool> saveCompany(EmpresaModel company) => guardarEmpresa(company);
  Future<bool> toggleCompanyActiveStatus(String id, bool isActive) => alternarEstadoEmpresa(id, isActive);
  Future<List<AsignacionEstudianteModel>> getStudentAssignments({String? query, bool? pendingOnly}) => obtenerAsignacionesEstudiante(query: query, pendingOnly: pendingOnly);
  Future<bool> assignStudent({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  }) => asignarEstudiante(
    assignmentId: assignmentId,
    academicTutorId: academicTutorId,
    companyTutorId: companyTutorId,
    companyId: companyId,
  );
  Future<Map<String, List<Map<String, String>>>> getAssignmentOptions() => obtenerOpcionesAsignacion();
  Future<Map<String, List<Map<String, String>>>> getAcademicHierarchy() => obtenerJerarquiaAcademica();
}