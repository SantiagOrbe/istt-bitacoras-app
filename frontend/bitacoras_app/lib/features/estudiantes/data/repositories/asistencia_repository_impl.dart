import 'dart:typed_data';

import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';
import 'package:bitacoras_app/features/estudiantes/domain/repositories/i_asistencia_repository.dart';

import '../datasources/asistencia_remote_datasource.dart';

class AsistenciaRepositoryImpl implements IAsistenciaRepository {
  final AsistenciaRemoteDataSource remoteDataSource;

  AsistenciaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UbicacionEmpresaModel> getAssignedCompanyLocation() {
    return remoteDataSource.obtenerUbicacionEmpresa();
  }

  @override
  Future<RegistroAsistenciaModel?> getCurrentRecord() async {
    final record = await getTodayRecord();
    return record?.exitTime == null ? record : null;
  }

  @override
  Future<RegistroAsistenciaModel?> getTodayRecord() async {
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
  Future<List<RegistroAsistenciaModel>> getAttendanceHistory() {
    return remoteDataSource.obtenerHistorial();
  }

  @override
  Future<Map<String, dynamic>> getStudentPracticeProgress() {
    return remoteDataSource.obtenerProgresoPracticas();
  }

  @override
  Future<Uint8List> downloadPracticeReportPdf() {
    return remoteDataSource.descargarReportePdf();
  }

  @override
  Future<bool> registerAttendance({
    required String type,
    required double latitude,
    required double longitude,
  }) async {
    final record = await remoteDataSource.registrarAsistencia(
      tipo: type,
      lat: latitude,
      lng: longitude,
    );
    return record != null;
  }
}