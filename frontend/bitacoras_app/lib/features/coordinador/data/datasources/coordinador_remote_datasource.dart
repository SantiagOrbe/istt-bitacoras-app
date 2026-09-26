import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorRemoteDataSource {
  final ApiClient apiClient;

  CoordinadorRemoteDataSource({required this.apiClient});

  Future<List<Map<String, dynamic>>> obtenerEstudiantes() =>
      _list('usuarios/estudiantes/');

  Future<List<Map<String, dynamic>>> obtenerCarreras() =>
      _list('academica/carreras/');

  Future<List<Map<String, dynamic>>> obtenerTutores() =>
      _list('usuarios/tutores/');

  Future<Map<String, dynamic>> obtenerDatosCarrera() async {
    final response = await apiClient.get('usuarios/coordinador/datos/');
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del coordinador no es válida.');
    }
    return response;
  }

  Future<List<Map<String, dynamic>>> _list(String endpoint) async {
    final response = await apiClient.get(endpoint);
    final values = response is List ? response : response['results'];
    if (values is! List) return [];
    return values.whereType<Map<String, dynamic>>().toList();
  }
}