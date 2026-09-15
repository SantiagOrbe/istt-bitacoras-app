import 'package:bitacoras_app/core/network/api_client.dart';

class BitacoraRemoteDataSource {
  final ApiClient apiClient;

  BitacoraRemoteDataSource({required this.apiClient});

  Future<List<Map<String, dynamic>>> obtenerBitacoras() async {
    final response = await apiClient.get('bitacoras/registros/');
    return _asList(response);
  }

  Future<Map<String, dynamic>> crearBitacora(
    Map<String, dynamic> data,
  ) async {
    return _asMap(await apiClient.post('bitacoras/registros/', body: data));
  }

  Future<Map<String, dynamic>> crearActividad(
    Map<String, dynamic> data,
  ) async {
    return _asMap(await apiClient.post('bitacoras/actividades/', body: data));
  }

  Future<Map<String, dynamic>> actualizarActividad(
    String id,
    Map<String, dynamic> data,
  ) async {
    return _asMap(await apiClient.put('bitacoras/actividades/$id/', body: data));
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    final values = response is List ? response : response['results'];
    if (values is! List) return [];
    return values.whereType<Map<String, dynamic>>().toList();
  }

  Map<String, dynamic> _asMap(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de bitácoras no es válida.');
    }
    return response;
  }
}