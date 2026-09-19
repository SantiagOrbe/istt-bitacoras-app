import 'package:bitacoras_app/core/network/api_client.dart';

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
}
