import 'package:bitacoras_app/features/inicio/domain/models/accion_rapida_model.dart';

import '../models/empresa_model.dart';
import '../models/asignacion_estudiante_model.dart';

abstract class IResponsablePracticasRepository {
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
}