import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class AsistenciaRepositorioImpl implements IAsistenciaRepositorio {
  final AsistenciaRemoteDataSource remoteDataSource;

  AsistenciaRepositorioImpl({required this.remoteDataSource});

  @override
  Future<UbicacionEmpresaModel> obtenerUbicacionEmpresaAsignada() {
    return remoteDataSource.obtenerUbicacionEmpresa();
  }

  @override
  Future<RegistroAsistenciaModel?> obtenerRegistroActual() async {
    final record = await obtenerRegistroHoy();
    return record?.exitTime == null ? record : null;
  }

  @override
  Future<RegistroAsistenciaModel?> obtenerRegistroHoy() async {
    final records = await remoteDataSource.obtenerHistorial();
    final today = DateTime.now();
    final todayText =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    for (final record in records) {
      if (record.date == todayText) {
        return record;
      }
    }

    return null;
  }

  @override
  Future<List<RegistroAsistenciaModel>> obtenerHistorialAsistencia() {
    return remoteDataSource.obtenerHistorial();
  }

  @override
  Future<Map<String, dynamic>> obtenerProgresoPracticasEstudiante() {
    return remoteDataSource.obtenerProgresoPracticas();
  }

  @override
  Future<Uint8List> descargarReportePracticasPdf() {
    return remoteDataSource.descargarReportePdf();
  }

  @override
  Future<bool> registrarAsistencia({
    required String tipo,
    required double latitud,
    required double longitud,
  }) async {
    final record = await remoteDataSource.registrarAsistencia(
      tipo: tipo,
      lat: latitud,
      lng: longitud,
    );
    return record != null;
  }
}