import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorRepositoryImpl implements ICoordinadorRepository {
  final CoordinadorRemoteDataSource remoteDataSource;

  CoordinadorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CoordinadorEstudianteModel>> getEstudiantes() async =>
      (await remoteDataSource.getEstudiantes())
          .map(CoordinadorEstudianteModel.fromJson)
          .toList();

  @override
  Future<List<CoordinadorCarreraModel>> getCarreras() async =>
      (await remoteDataSource.getCarreras())
          .map(CoordinadorCarreraModel.fromJson)
          .toList();

  @override
  Future<List<CoordinadorTutorModel>> getTutores() async =>
      (await remoteDataSource.getTutores())
          .map(CoordinadorTutorModel.fromJson)
          .toList();

  @override
  Future<CoordinadorDatosModel> getDatosCarrera() async =>
      CoordinadorDatosModel.fromJson(await remoteDataSource.getDatosCarrera());
}
