import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class BitacoraRepositorioImpl {
  final BitacoraRemoteDataSource remoteDataSource;

  BitacoraRepositorioImpl({required this.remoteDataSource});

  Future<List<RegistroPracticaModel>> obtenerBitacoras() async {
    final response = await remoteDataSource.obtenerBitacoras();
    return response.map(RegistroPracticaModel.fromJson).toList();
  }

  Future<RegistroPracticaModel> crearBitacora(
    RegistroPracticaModel bitacora,
  ) async {
    final response = await remoteDataSource.crearBitacora(bitacora.toJson());
    return RegistroPracticaModel.fromJson(response);
  }

  Future<Map<String, dynamic>> crearActividad(Map<String, dynamic> data) {
    return remoteDataSource.crearActividad(data);
  }

  Future<Map<String, dynamic>> actualizarActividad(
    String id,
    Map<String, dynamic> data,
  ) {
    return remoteDataSource.actualizarActividad(id, data);
  }
}