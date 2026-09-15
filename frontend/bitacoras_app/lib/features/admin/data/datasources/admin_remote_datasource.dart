import 'package:bitacoras_app/core/network/api_client.dart';

class AdminRemoteDataSource {
  final ApiClient apiClient;

  AdminRemoteDataSource({required this.apiClient});

  Future<List<Map<String, dynamic>>> getUsers() => _list('usuarios/');
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) =>
      _map(apiClient.post('usuarios/', body: data));
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data) =>
      _map(apiClient.put('usuarios/$id/', body: data));
  Future<void> deleteUser(String id) => apiClient.delete('usuarios/$id/').then((_) {});

  Future<List<Map<String, dynamic>>> getCycles() => _list('academica/ciclos/');
  Future<Map<String, dynamic>> createCycle(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/ciclos/', body: data));
  Future<Map<String, dynamic>> updateCycle(String id, Map<String, dynamic> data) =>
      _map(apiClient.put('academica/ciclos/$id/', body: data));

  Future<List<Map<String, dynamic>>> getParallels() => _list('academica/paralelos/');
  Future<Map<String, dynamic>> createParallel(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/paralelos/', body: data));
  Future<Map<String, dynamic>> updateParallel(String id, Map<String, dynamic> data) =>
      _map(apiClient.put('academica/paralelos/$id/', body: data));

  Future<List<Map<String, dynamic>>> getCareers() => _list('academica/carreras/');
  Future<Map<String, dynamic>> createCareer(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/carreras/', body: data));

  Future<List<Map<String, dynamic>>> getPeriods() => _list('academica/periodos/');
  Future<Map<String, dynamic>> createPeriod(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/periodos/', body: data));
  Future<Map<String, dynamic>> updatePeriod(String id, Map<String, dynamic> data) =>
      _map(apiClient.put('academica/periodos/$id/', body: data));

  Future<List<Map<String, dynamic>>> getCareerPeriodConfigurations() =>
      _list('academica/carreras-periodos/');
  Future<Map<String, dynamic>> saveCareerPeriodConfiguration(
    Map<String, dynamic> data,
  ) => _map(apiClient.post('academica/carreras-periodos/', body: data));

  Future<List<Map<String, dynamic>>> getPracticeLogs() =>
      _list('bitacoras/registros/');

  Future<List<Map<String, dynamic>>> _list(String endpoint) async {
    final response = await apiClient.get(endpoint);
    final values = response is List ? response : response['results'];
    if (values is! List) return [];
    return values.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> _map(Future<dynamic> response) async {
    final value = await response;
    if (value is! Map<String, dynamic>) {
      throw const FormatException('La respuesta administrativa no es válida.');
    }
    return value;
  }
}