import 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';

import '../models/registro_asistencia_model.dart';

abstract class IAsistenciaRepository {
  Future<UbicacionEmpresaModel> getAssignedCompanyLocation();
  Future<RegistroAsistenciaModel?> getCurrentRecord();
  Future<List<RegistroAsistenciaModel>> getAttendanceHistory();
  Future<bool> registerAttendance({
    required String type, // 'ENTRY' o 'EXIT'
    required double latitude,
    required double longitude,
  });
}
