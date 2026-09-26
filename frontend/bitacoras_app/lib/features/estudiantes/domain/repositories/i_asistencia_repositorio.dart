import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

abstract class IAsistenciaRepositorio {
  Future<UbicacionEmpresaModel> obtenerUbicacionEmpresaAsignada();
  Future<RegistroAsistenciaModel?> obtenerRegistroActual();
  Future<RegistroAsistenciaModel?> obtenerRegistroHoy();
  Future<List<RegistroAsistenciaModel>> obtenerHistorialAsistencia();
  Future<Map<String, dynamic>> obtenerProgresoPracticasEstudiante();
  Future<Uint8List> descargarReportePracticasPdf();
  Future<bool> registrarAsistencia({
    required String tipo,
    required double latitud,
    required double longitud,
  });
}
