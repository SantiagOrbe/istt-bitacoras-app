import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class ResponsablePracticasRepositoryImpl
    implements IResponsablePracticasRepository {
  final ResponsablePracticasRemoteDataSource remoteDataSource;
  Map<String, dynamic>? _datos;

  ResponsablePracticasRepositoryImpl({required this.remoteDataSource});

  @override
  void invalidarCache() {
    _datos = null;
  }

  @override
  List<AccionRapidaModel> accionesResponsablePracticas() {
    return [
      AccionRapidaModel(
        title: 'Gestión de Empresas',
        subtitle: 'Catálogo de instituciones y convenios',
        icon: Icons.business_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.empresasResponsable,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Asignación de Estudiantes',
        subtitle: 'Vincular tutores académicos y empresariales',
        icon: Icons.person_add_alt_1_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.asignacionesResponsable,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Mi perfil',
        subtitle: 'Datos personales y cuenta',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.perfilUsuario,
        onTap: () {},
      ),
    ];
  }

  Future<Map<String, dynamic>> _cargarDatos() async {
    return _datos ??= await remoteDataSource.obtenerDatos();
  }

  @override
  Future<List<EmpresaModel>> obtenerEmpresas({String? query}) async {
    final data = await _cargarDatos();
    final valores = (data['empresas'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(EmpresaModel.fromJson)
        .toList();
    final busquedaNormalizada = query?.trim().toLowerCase() ?? '';
    if (busquedaNormalizada.isEmpty) return valores;
    return valores.where((empresa) {
      return '${empresa.name} ${empresa.ruc} ${empresa.address}'
          .toLowerCase()
          .contains(busquedaNormalizada);
    }).toList();
  }

  @override
  Future<EmpresaModel?> obtenerEmpresaPorId(String id) async {
    final empresas = await obtenerEmpresas();
    for (final empresa in empresas) {
      if (empresa.id == id) return empresa;
    }
    return null;
  }

  @override
  Future<bool> guardarEmpresa(EmpresaModel empresa) async {
    final datos = empresa.toJson();
    if (empresa.id.isEmpty) {
      await remoteDataSource.crearEmpresa(datos);
    } else {
      await remoteDataSource.actualizarEmpresa(empresa.id, datos);
    }
    invalidarCache();
    return true;
  }

  @override
  Future<bool> alternarEstadoEmpresa(String id, bool estaActivo) async {
    await remoteDataSource.actualizarEstadoEmpresa(id, estaActivo);
    invalidarCache();
    return true;
  }

  @override
  Future<List<AsignacionEstudianteModel>> obtenerAsignacionesEstudiante({
    String? query,
    bool? pendingOnly,
  }) async {
    final data = await _cargarDatos();
    final nombreCarrera =
        (data['carrera'] as Map<String, dynamic>?)?['nombre']?.toString() ?? '';
    final empresas = {
      for (final item in (data['empresas'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>())
        item['id'].toString(): item['nombre']?.toString() ?? '',
    };
    final tutoresAcademicos = {
      for (final item in (data['tutores_academicos'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>())
        item['id'].toString(): item['nombre']?.toString() ?? '',
    };
    final tutoresEmpresariales = {
      for (final item in (data['tutores_empresariales'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>())
        item['id'].toString(): item['nombre']?.toString() ?? '',
    };

    var valores = (data['estudiantes'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) {
      final tutorAcademicoId = item['tutor_academico_id']?.toString();
      final tutorEmpresarialId = item['tutor_empresarial_id']?.toString();
      final empresaId = item['empresa_id']?.toString();
      return AsignacionEstudianteModel(
        id: item['id'].toString(),
        studentId: item['id'].toString(),
        studentName: item['nombre']?.toString() ?? '',
        studentIdentification: item['cedula']?.toString() ?? '',
        career: nombreCarrera,
        academicTutorId: tutorAcademicoId,
        academicTutorName:
            tutorAcademicoId == null ? null : tutoresAcademicos[tutorAcademicoId],
        companyTutorId: tutorEmpresarialId,
        companyTutorName: tutorEmpresarialId == null
            ? null
            : tutoresEmpresariales[tutorEmpresarialId],
        companyId: empresaId,
        companyName: empresaId == null ? null : empresas[empresaId],
        isAssigned: tutorAcademicoId != null &&
            tutorEmpresarialId != null &&
            empresaId != null,
        semesterId: item['semestre_id']?.toString(),
        parallelId: item['paralelo_id']?.toString(),
      );
    }).toList();

    final semestresPermitidos = (data['semestres'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => item['id'].toString())
        .toSet();
    final paralelosPermitidos = (data['paralelos'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => item['id'].toString())
        .toSet();
    valores = valores.where((item) {
      return semestresPermitidos.contains(item.semesterId) &&
          paralelosPermitidos.contains(item.parallelId);
    }).toList();

    if (pendingOnly == true) {
      valores = valores.where((item) => !item.isAssigned).toList();
    }
    final consultaNormalizada = query?.trim().toLowerCase() ?? '';
    if (consultaNormalizada.isNotEmpty) {
      valores = valores
          .where((item) =>
              '${item.studentName} ${item.studentIdentification}'
                  .toLowerCase()
                  .contains(consultaNormalizada))
          .toList();
    }
    return valores;
  }

  @override
  Future<bool> asignarEstudiante({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  }) async {
    await remoteDataSource.asignarEstudiante(
      estudianteId: assignmentId,
      tutorAcademicoId: academicTutorId,
      tutorEmpresarialId: companyTutorId,
      empresaId: companyId,
    );
    _datos = null;
    return true;
  }

  @override
  Future<Map<String, List<Map<String, String>>>> obtenerOpcionesAsignacion() async {
    final data = await _cargarDatos();
    List<Map<String, String>> valores(String clave) =>
        (data[clave] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((item) => {
                  'id': item['id'].toString(),
                  'name': item['nombre']?.toString() ?? '',
                  if (item['empresa_id'] != null)
                    'companyId': item['empresa_id'].toString(),
                })
            .toList();
    return {
      'academicTutors': valores('tutores_academicos'),
      'companyTutors': valores('tutores_empresariales'),
      'companies': valores('empresas'),
    };
  }

  @override
  Future<Map<String, List<Map<String, String>>>> obtenerJerarquiaAcademica() async {
    final data = await _cargarDatos();
    List<Map<String, String>> valores(String clave) =>
        (data[clave] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((item) => item.map(
                  (clave, valor) => MapEntry(clave, valor.toString()),
                ))
            .toList();
    return {
      'semestres': valores('semestres'),
      'paralelos': valores('paralelos'),
    };
  }

  @override
  void invalidateCache() => invalidarCache();

  @override
  List<AccionRapidaModel> responsablePracticasActions() => accionesResponsablePracticas();

  @override
  Future<List<EmpresaModel>> getCompanies({String? query}) => obtenerEmpresas(query: query);

  @override
  Future<EmpresaModel?> getCompanyById(String id) => obtenerEmpresaPorId(id);

  @override
  Future<bool> saveCompany(EmpresaModel company) => guardarEmpresa(company);

  @override
  Future<bool> toggleCompanyActiveStatus(String id, bool isActive) => alternarEstadoEmpresa(id, isActive);

  @override
  Future<List<AsignacionEstudianteModel>> getStudentAssignments({String? query, bool? pendingOnly}) => obtenerAsignacionesEstudiante(query: query, pendingOnly: pendingOnly);

  @override
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

  @override
  Future<Map<String, List<Map<String, String>>>> getAssignmentOptions() => obtenerOpcionesAsignacion();

  @override
  Future<Map<String, List<Map<String, String>>>> getAcademicHierarchy() => obtenerJerarquiaAcademica();
}

