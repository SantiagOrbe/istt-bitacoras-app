import 'package:bitacoras_app/features/inicio/domain/models/accion_rapida_model.dart';

import '../../domain/models/asignacion_estudiante_model.dart';
import '../../domain/models/empresa_model.dart';
import '../../domain/repositories/i_responsable_practicas_repository.dart';
import '../datasources/responsable_practicas_remote_datasource.dart';

class ResponsablePracticasRepositoryImpl
    implements IResponsablePracticasRepository {
  final ResponsablePracticasRemoteDataSource remoteDataSource;
  Map<String, dynamic>? _datos;

  ResponsablePracticasRepositoryImpl({required this.remoteDataSource});

  @override
  void invalidateCache() {
    _datos = null;
  }

  @override
  List<AccionRapidaModel> responsablePracticasActions() => const [];

  Future<Map<String, dynamic>> _load() async {
    return _datos ??= await remoteDataSource.getDatos();
  }

  @override
  Future<List<EmpresaModel>> getCompanies({String? query}) async {
    final data = await _load();
    final values = (data['empresas'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(EmpresaModel.fromJson)
        .toList();
    final normalized = query?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty) return values;
    return values.where((company) {
      return '${company.name} ${company.ruc} ${company.address}'
          .toLowerCase()
          .contains(normalized);
    }).toList();
  }

  @override
  Future<EmpresaModel?> getCompanyById(String id) async {
    final companies = await getCompanies();
    for (final company in companies) {
      if (company.id == id) return company;
    }
    return null;
  }

  @override
  Future<bool> saveCompany(EmpresaModel company) async => false;

  @override
  Future<bool> toggleCompanyActiveStatus(String id, bool isActive) async => false;

  @override
  Future<List<AsignacionEstudianteModel>> getStudentAssignments({
    String? query,
    bool? pendingOnly,
  }) async {
    final data = await _load();
    final careerName = (data['carrera'] as Map<String, dynamic>?)?['nombre']?.toString() ?? '';
    final companies = {
      for (final item in (data['empresas'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>())
        item['id'].toString(): item['nombre']?.toString() ?? '',
    };
    final academicTutors = {
      for (final item in (data['tutores_academicos'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>())
        item['id'].toString(): item['nombre']?.toString() ?? '',
    };
    final companyTutors = {
      for (final item in (data['tutores_empresariales'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>())
        item['id'].toString(): item['nombre']?.toString() ?? '',
    };

    var values = (data['estudiantes'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) {
      final academicId = item['tutor_academico_id']?.toString();
      final companyTutorId = item['tutor_empresarial_id']?.toString();
      final companyId = item['empresa_id']?.toString();
      return AsignacionEstudianteModel(
        id: item['id'].toString(),
        studentId: item['id'].toString(),
        studentName: item['nombre']?.toString() ?? '',
        studentIdentification: item['cedula']?.toString() ?? '',
        career: careerName,
        academicTutorId: academicId,
        academicTutorName: academicId == null ? null : academicTutors[academicId],
        companyTutorId: companyTutorId,
        companyTutorName: companyTutorId == null ? null : companyTutors[companyTutorId],
        companyId: companyId,
        companyName: companyId == null ? null : companies[companyId],
        isAssigned: academicId != null && companyTutorId != null && companyId != null,
        semesterId: item['semestre_id']?.toString(),
        parallelId: item['paralelo_id']?.toString(),
      );
    }).toList();

    final allowedSemesterIds = (data['semestres'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => item['id'].toString())
        .toSet();
    final allowedParallelIds = (data['paralelos'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => item['id'].toString())
        .toSet();
    values = values.where((item) {
      return allowedSemesterIds.contains(item.semesterId) &&
          allowedParallelIds.contains(item.parallelId);
    }).toList();

    if (pendingOnly == true) {
      values = values.where((item) => !item.isAssigned).toList();
    }
    final normalized = query?.trim().toLowerCase() ?? '';
    if (normalized.isNotEmpty) {
      values = values.where((item) => '${item.studentName} ${item.studentIdentification}'.toLowerCase().contains(normalized)).toList();
    }
    return values;
  }

  @override
  Future<bool> assignStudent({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  }) async {
    await remoteDataSource.assignStudent(
      studentId: assignmentId,
      academicTutorId: academicTutorId,
      companyTutorId: companyTutorId,
      companyId: companyId,
    );
    _datos = null;
    return true;
  }

  @override
  Future<Map<String, List<Map<String, String>>>> getAssignmentOptions() async {
    final data = await _load();
    List<Map<String, String>> values(String key) =>
        (data[key] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((item) => {
                  'id': item['id'].toString(),
                  'name': item['nombre']?.toString() ?? '',
                  if (item['empresa_id'] != null)
                    'companyId': item['empresa_id'].toString(),
                })
            .toList();
    return {
      'academicTutors': values('tutores_academicos'),
      'companyTutors': values('tutores_empresariales'),
      'companies': values('empresas'),
    };
  }

  @override
  Future<Map<String, List<Map<String, String>>>> getAcademicHierarchy() async {
    final data = await _load();
    List<Map<String, String>> values(String key) =>
        (data[key] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((item) => item.map(
                  (name, value) => MapEntry(name, value.toString()),
                ))
            .toList();
    return {
      'semestres': values('semestres'),
      'paralelos': values('paralelos'),
    };
  }
}
