import 'dart:typed_data';

import 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';

import '../models/registro_asistencia_model.dart';

abstract class IAsistenciaRepository {
  Future<UbicacionEmpresaModel> getAssignedCompanyLocation();
  Future<RegistroAsistenciaModel?> getCurrentRecord();
  Future<RegistroAsistenciaModel?> getTodayRecord();
  Future<List<RegistroAsistenciaModel>> getAttendanceHistory();
  Future<Map<String, dynamic>> getStudentPracticeProgress();
  Future<Uint8List> downloadPracticeReportPdf();
  Future<bool> registerAttendance({
    required String type, // 'ENTRY' o 'EXIT'
    required double latitude,
    required double longitude,
  });
}
