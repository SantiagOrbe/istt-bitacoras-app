import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorRepositoryImpl implements ICoordinadorRepository {
  final CoordinadorRemoteDataSource remoteDataSource;

  CoordinadorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CoordinadorEstudianteModel>> obtenerEstudiantes() async =>
      (await remoteDataSource.obtenerEstudiantes())
          .map(CoordinadorEstudianteModel.fromJson)
          .toList();

  @override
  Future<List<CoordinadorCarreraModel>> obtenerCarreras() async =>
      (await remoteDataSource.obtenerCarreras())
          .map(CoordinadorCarreraModel.fromJson)
          .toList();

  @override
  Future<List<CoordinadorTutorModel>> obtenerTutores() async =>
      (await remoteDataSource.obtenerTutores())
          .map(CoordinadorTutorModel.fromJson)
          .toList();

  @override
  Future<CoordinadorDatosModel> obtenerDatosCarrera() async =>
      CoordinadorDatosModel.fromJson(
        await remoteDataSource.obtenerDatosCarrera(),
      );
}
