import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class ResponsablePracticasRemoteDataSource {
  final ApiClient apiClient;

  ResponsablePracticasRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> getDatos() async {
    final response = await apiClient.get(
      'usuarios/responsable-practicas/datos/',
    );
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del responsable no es válida.');
    }
    return response;
  }

  Future<void> assignStudent({
    required String studentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  }) async {
    await apiClient.post(
      'usuarios/responsable-practicas/datos/',
      body: {
        'estudiante_id': int.tryParse(studentId) ?? studentId,
        'tutor_academico_id': int.tryParse(academicTutorId) ?? academicTutorId,
        'tutor_empresarial_id': int.tryParse(companyTutorId) ?? companyTutorId,
        'empresa_id': int.tryParse(companyId) ?? companyId,
      },
    );
  }

  Future<Map<String, dynamic>> createCompany(Map<String, dynamic> data) async {
    final response = await apiClient.post('empresas/empresas/', body: data);
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de la empresa no es válida.');
    }
    return response;
  }

  Future<Map<String, dynamic>> updateCompany(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.put('empresas/empresas/$id/', body: data);
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de la empresa no es válida.');
    }
    return response;
  }

  Future<void> updateCompanyStatus(String id, bool isActive) async {
    await apiClient.patch(
      'empresas/empresas/$id/',
      body: {'estado': isActive},
    );
  }
}
