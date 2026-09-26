import 'package:bitacoras_app/features/admin/admin.dart';

class AdminRemoteDataSource {
  final ApiClient apiClient;

  AdminRemoteDataSource({required this.apiClient});

  Future<List<Map<String, dynamic>>> obtenerUsuarios({
    bool? isActive,
    String? role,
    String? search,
  }) => _list(
    'usuarios/',
    queryParameters: {
      if (isActive != null) 'is_active': isActive.toString(),
      if (role != null && role.isNotEmpty) 'rol': role,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    },
  );

  Future<Map<String, dynamic>> crearUsuario(Map<String, dynamic> data) =>
      _map(apiClient.post('usuarios/', body: data));

  Future<Map<String, dynamic>> actualizarUsuario(
    String id,
    Map<String, dynamic> data,
  ) => _map(apiClient.put('usuarios/$id/', body: data));

  Future<void> cambiarEstadoUsuario(String id, bool isActive) => apiClient
      .patch('usuarios/$id/', body: {'estado': isActive, 'is_active': isActive})
      .then((_) {});

  Future<void> eliminarUsuario(String id) => apiClient
      .patch('usuarios/$id/', body: {'estado': false, 'is_active': false})
      .then((_) {});

  Future<List<Map<String, dynamic>>> obtenerEmpresas() =>
      _list('empresas/empresas/');

  Future<Map<String, dynamic>> crearEmpresa(Map<String, dynamic> data) =>
      _map(apiClient.post('empresas/empresas/', body: data));

  Future<Map<String, dynamic>> actualizarEmpresa(
    String id,
    Map<String, dynamic> data,
  ) => _map(apiClient.put('empresas/empresas/$id/', body: data));

  Future<void> desactivarEmpresa(String id, {bool unlinkStudents = false}) =>
      apiClient
          .patch(
            'empresas/empresas/$id/',
            body: {'estado': false, 'unlink_students': unlinkStudents},
          )
          .then((_) {});

  Future<List<Map<String, String>>> obtenerEstudiantesVinculadosEmpresa(
    String id,
  ) async {
    final response = await apiClient.get(
      'empresas/empresas/$id/estudiantes-vinculados/',
    );
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => {
            'id': item['id']?.toString() ?? '',
            'nombre': item['nombre']?.toString() ?? '',
            'email': item['email']?.toString() ?? '',
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> obtenerCiclos({String? careerId}) => _list(
    'academica/semestres/',
    queryParameters: {
      if (careerId != null && careerId.isNotEmpty) 'carrera': careerId,
    },
  );

  Future<Map<String, dynamic>> crearCiclo(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/semestres/', body: data));

  Future<Map<String, dynamic>> actualizarCiclo(
    String id,
    Map<String, dynamic> data,
  ) => _map(apiClient.put('academica/semestres/$id/', body: data));

  Future<List<Map<String, dynamic>>> obtenerParalelos({
    String? careerId,
    String? semesterId,
  }) => _list(
    'academica/paralelos/',
    queryParameters: {
      if (careerId != null && careerId.isNotEmpty) 'carrera': careerId,
      if (semesterId != null && semesterId.isNotEmpty) 'semestre': semesterId,
    },
  );

  Future<Map<String, dynamic>> crearParalelo(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/paralelos/', body: data));

  Future<Map<String, dynamic>> actualizarParalelo(
    String id,
    Map<String, dynamic> data,
  ) => _map(apiClient.put('academica/paralelos/$id/', body: data));

  Future<List<Map<String, dynamic>>> obtenerEstudiantesParalelo(
    String parallelId,
  ) => _list('academica/paralelos/$parallelId/estudiantes/');

  Future<Map<String, dynamic>> asignarEstudiantesParalelo(
    String parallelId,
    List<int> studentIds,
  ) => _map(
    apiClient.post(
      'academica/paralelos/$parallelId/estudiantes/',
      body: {'estudiante_ids': studentIds},
    ),
  );

  Future<Map<String, dynamic>> eliminarEstudiantesParalelo(String parallelId) =>
      _map(apiClient.delete('academica/paralelos/$parallelId/estudiantes/'));

  Future<List<Map<String, dynamic>>> obtenerCarreras() =>
      _list('academica/carreras/');

  Future<Map<String, dynamic>> crearCarrera(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/carreras/', body: data));

  Future<Map<String, dynamic>> actualizarCarrera(
    String id,
    Map<String, dynamic> data, {
    bool confirmDesactivate = false,
  }) => _map(
    apiClient.put(
      'academica/carreras/$id/',
      body: {...data, if (confirmDesactivate) 'confirm_desactivate': true},
    ),
  );

  Future<List<Map<String, dynamic>>> obtenerPeriodos() =>
      _list('academica/periodos/');

  Future<Map<String, dynamic>> crearPeriodo(Map<String, dynamic> data) =>
      _map(apiClient.post('academica/periodos/', body: data));

  Future<Map<String, dynamic>> actualizarPeriodo(
    String id,
    Map<String, dynamic> data, {
    bool confirmDesactivate = false,
  }) => _map(
    apiClient.put(
      'academica/periodos/$id/',
      body: {...data, if (confirmDesactivate) 'confirm_desactivate': true},
    ),
  );

  Future<List<Map<String, dynamic>>> obtenerConfiguracionesPeriodoCarrera() =>
      _list('academica/carreras-periodos/');

  Future<Map<String, dynamic>> guardarConfiguracionPeriodoCarrera(
    Map<String, dynamic> data,
  ) => _map(apiClient.post('academica/carreras-periodos/', body: data));

  Future<Map<String, dynamic>> guardarConfiguracionesCarrerasPeriodo(
    String periodId,
    List<Map<String, dynamic>> careers,
  ) => _map(
    apiClient.post(
      'academica/carreras-periodos/configurar-periodo/',
      body: {'periodo': periodId, 'carreras': careers},
    ),
  );

  Future<List<Map<String, dynamic>>> obtenerRegistrosPractica() =>
      _list('bitacoras/registros/');

  Future<List<Map<String, dynamic>>> _list(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await apiClient.get(
      endpoint,
      queryParameters: queryParameters,
    );
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
