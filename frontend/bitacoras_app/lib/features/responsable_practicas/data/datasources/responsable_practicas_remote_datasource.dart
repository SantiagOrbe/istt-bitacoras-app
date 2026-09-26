import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class ResponsablePracticasRemoteDataSource {
  final ApiClient apiClient;

  ResponsablePracticasRemoteDataSource({required this.apiClient});

  /// Obtiene los datos del responsable de prácticas.
  Future<Map<String, dynamic>> obtenerDatos() async {
    final response = await apiClient.get(
      'usuarios/responsable-practicas/datos/',
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del responsable no es válida.');
    }
    return response;
  }

  /// Alias de compatibilidad con la nomenclatura anterior.
  Future<Map<String, dynamic>> getDatos() => obtenerDatos();

  /// Asigna un estudiante con sus tutores y empresa.
  Future<void> asignarEstudiante({
    required String estudianteId,
    required String tutorAcademicoId,
    required String tutorEmpresarialId,
    required String empresaId,
  }) async {
    await apiClient.post(
      'usuarios/responsable-practicas/datos/',
      body: {
        'estudiante_id': int.tryParse(estudianteId) ?? estudianteId,
        'tutor_academico_id': int.tryParse(tutorAcademicoId) ?? tutorAcademicoId,
        'tutor_empresarial_id': int.tryParse(tutorEmpresarialId) ?? tutorEmpresarialId,
        'empresa_id': int.tryParse(empresaId) ?? empresaId,
      },
    );
  }

  /// Alias de compatibilidad con la nomenclatura anterior.
  Future<void> assignStudent({
    required String studentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  }) async {
    await asignarEstudiante(
      estudianteId: studentId,
      tutorAcademicoId: academicTutorId,
      tutorEmpresarialId: companyTutorId,
      empresaId: companyId,
    );
  }

  /// Crea una nueva empresa.
  Future<Map<String, dynamic>> crearEmpresa(Map<String, dynamic> datos) async {
    final response = await apiClient.post('empresas/empresas/', body: datos);
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de la empresa no es válida.');
    }
    return response;
  }

  /// Alias de compatibilidad con la nomenclatura anterior.
  Future<Map<String, dynamic>> createCompany(Map<String, dynamic> data) =>
      crearEmpresa(data);

  /// Actualiza una empresa existente.
  Future<Map<String, dynamic>> actualizarEmpresa(
    String id,
    Map<String, dynamic> datos,
  ) async {
    final response = await apiClient.put('empresas/empresas/$id/', body: datos);
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de la empresa no es válida.');
    }
    return response;
  }

  /// Alias de compatibilidad con la nomenclatura anterior.
  Future<Map<String, dynamic>> updateCompany(
    String id,
    Map<String, dynamic> data,
  ) =>
      actualizarEmpresa(id, data);

  /// Actualiza el estado de una empresa.
  Future<void> actualizarEstadoEmpresa(String id, bool estaActivo) async {
    await apiClient.patch(
      'empresas/empresas/$id/',
      body: {'estado': estaActivo},
    );
  }

  /// Alias de compatibilidad con la nomenclatura anterior.
  Future<void> updateCompanyStatus(String id, bool isActive) async {
    await actualizarEstadoEmpresa(id, isActive);
  }
}
