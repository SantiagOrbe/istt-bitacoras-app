import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class AsistenciaRemoteDataSource {
  final ApiClient apiClient;

  AsistenciaRemoteDataSource({required this.apiClient});

  Future<List<RegistroAsistenciaModel>> obtenerHistorial() async {
    final response = await apiClient.get('bitacoras/registros/');
    final records = response is List ? response : response['results'];

    if (records is! List) return [];

    return records
        .whereType<Map<String, dynamic>>()
        .map(RegistroAsistenciaModel.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> obtenerProgresoPracticas() async {
    final response = await apiClient.get('bitacoras/registros/mi-avance/');
    return response is Map<String, dynamic>
        ? response
        : <String, dynamic>{
            'horas_acumuladas': 0.0,
            'horas_requeridas': 0,
            'porcentaje': 0.0,
            'completo': false,
          };
  }

  Future<RegistroAsistenciaModel?> registrarAsistencia({
    required String tipo,
    required double lat,
    required double lng,
  }) async {
    final endpoint = tipo == 'EXIT'
        ? 'bitacoras/registros/check-out/'
        : 'bitacoras/registros/check-in/';
    final response = await apiClient.post(
      endpoint,
      body: {
        'tipo': tipo,
        'latitud': lat,
        'longitud': lng,
      },
    );

    return response is Map<String, dynamic>
        ? RegistroAsistenciaModel.fromJson(response)
        : null;
  }

  Future<Uint8List> descargarReportePdf() async {
    return apiClient.downloadBinary('bitacoras/registros/mi-reporte-pdf/');
  }

  Future<UbicacionEmpresaModel> obtenerUbicacionEmpresa() async {
    final profile = await apiClient.get('usuarios/perfil/');
    final rawProfile = profile is Map<String, dynamic> ? profile['perfil'] ?? profile : null;
    final profileData = rawProfile is Map<String, dynamic> ? rawProfile : null;

    final dynamic companyId = profileData?['empresa'] ??
        profileData?['empresa_id'] ??
        (profile is Map<String, dynamic> ? profile['empresa'] : null) ??
        (profile is Map<String, dynamic> ? profile['empresa_id'] : null);

    if (companyId == null || companyId == '' || companyId == 'null') {
      throw StateError('El estudiante no tiene una empresa asignada.');
    }

    final company = await apiClient.get('empresas/empresas/$companyId/');
    if (company is! Map<String, dynamic>) {
      throw StateError('La respuesta de la empresa no es válida.');
    }

    final location = company['ubicacion'];
    final coordinates = location is Map<String, dynamic>
        ? location['coordinates'] as List<dynamic>?
        : null;
        final latitude = _asDouble(company['latitud']) ??
        (coordinates != null && coordinates.length > 1
          ? _asDouble(coordinates[1])
            : null);
        final longitude = _asDouble(company['longitud']) ??
        (coordinates != null && coordinates.isNotEmpty
          ? _asDouble(coordinates[0])
            : null);

        final pointCoordinates = _parsePoint(company['ubicacion']);
        final resolvedLatitude = latitude ?? pointCoordinates?.$1;
        final resolvedLongitude = longitude ?? pointCoordinates?.$2;

        if (resolvedLatitude == null || resolvedLongitude == null) {
      throw StateError('La empresa no tiene una ubicación GPS válida.');
    }

    return UbicacionEmpresaModel(
      name: company['nombre'] as String? ?? '',
      latitude: resolvedLatitude,
      longitude: resolvedLongitude,
      allowedRadiusMeters:
          _asDouble(company['radio_permitido']) ?? 200.0,
    );
  }

  double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  (double, double)? _parsePoint(dynamic value) {
    final text = value?.toString() ?? '';
    final match = RegExp(
      r'POINT\s*\(\s*(-?\d+(?:\.\d+)?)\s+(-?\d+(?:\.\d+)?)\s*\)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) return null;

    final longitude = double.tryParse(match.group(1)!);
    final latitude = double.tryParse(match.group(2)!);
    return longitude != null && latitude != null
        ? (latitude, longitude)
        : null;
  }
}