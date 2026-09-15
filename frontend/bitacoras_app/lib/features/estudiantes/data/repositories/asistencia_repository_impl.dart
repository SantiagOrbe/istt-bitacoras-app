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
    final records = await remoteDataSource.obtenerHistorial();

    for (final record in records) {
      if (record.status == 'En curso' || record.exitTime == null) {
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