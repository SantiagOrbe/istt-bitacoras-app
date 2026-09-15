import 'package:bitacoras_app/core/network/api_client.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';

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

  Future<UbicacionEmpresaModel> obtenerUbicacionEmpresa() async {
    final profile = await apiClient.get('usuarios/perfil/');
    final profileData = profile is Map<String, dynamic>
        ? profile['perfil'] as Map<String, dynamic>?
        : null;
    final companyId = profileData?['empresa'];

    if (companyId == null) {
      throw StateError('El estudiante no tiene una empresa asignada.');
    }

    final company = await apiClient.get('empresas/$companyId/');
    if (company is! Map<String, dynamic>) {
      throw StateError('La respuesta de la empresa no es válida.');
    }

    final location = company['ubicacion'];
    final coordinates = location is Map<String, dynamic>
        ? location['coordinates'] as List<dynamic>?
        : null;

    if (coordinates == null || coordinates.length < 2) {
      throw StateError('La empresa no tiene una ubicación GPS válida.');
    }

    return UbicacionEmpresaModel(
      name: company['nombre'] as String? ?? '',
      latitude: (coordinates[1] as num).toDouble(),
      longitude: (coordinates[0] as num).toDouble(),
      allowedRadiusMeters:
          (company['radio_permitido'] as num?)?.toDouble() ?? 200.0,
    );
  }
}