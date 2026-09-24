import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class BitacoraRepositoryImpl {
  final BitacoraRemoteDataSource remoteDataSource;

  BitacoraRepositoryImpl({required this.remoteDataSource});

  Future<List<RegistroPracticaModel>> getBitacoras() async {
    final response = await remoteDataSource.obtenerBitacoras();
    return response.map(RegistroPracticaModel.fromJson).toList();
  }

  Future<RegistroPracticaModel> createBitacora(
    RegistroPracticaModel bitacora,
  ) async {
    final response = await remoteDataSource.crearBitacora(bitacora.toJson());
    return RegistroPracticaModel.fromJson(response);
  }

  Future<Map<String, dynamic>> createActivity(Map<String, dynamic> data) {
    return remoteDataSource.crearActividad(data);
  }

  Future<Map<String, dynamic>> updateActivity(
    String id,
    Map<String, dynamic> data,
  ) {
    return remoteDataSource.actualizarActividad(id, data);
  }
}