import '../../domain/repositories/i_coordinador_repository.dart';
import '../datasources/coordinador_remote_datasource.dart';

class CoordinadorRepositoryImpl implements ICoordinadorRepository {
  final CoordinadorRemoteDataSource remoteDataSource;

  CoordinadorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Map<String, dynamic>>> getEstudiantes() =>
      remoteDataSource.getEstudiantes();

  @override
  Future<List<Map<String, dynamic>>> getCarreras() =>
      remoteDataSource.getCarreras();

  @override
  Future<List<Map<String, dynamic>>> getTutores() => remoteDataSource.getTutores();
}