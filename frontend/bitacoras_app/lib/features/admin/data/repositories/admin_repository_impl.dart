import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/ciclo_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/configuracion_periodo_carrera_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/paralelo_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/periodo_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';

import '../datasources/admin_remote_datasource.dart';
import '../../domain/repositories/i_admin_repository.dart';

class AdminRepositoryImpl implements IAdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UsuarioModel>> getUsers() async => (await remoteDataSource.getUsers())
      .map(UsuarioModel.fromJson)
      .toList();

  @override
  Future<bool> createUser(UsuarioModel user) async {
    await remoteDataSource.createUser(user.toJson());
    return true;
  }

  @override
  Future<bool> updateUser(UsuarioModel user) async {
    await remoteDataSource.updateUser(user.id, user.toJson());
    return true;
  }

  @override
  Future<bool> deleteUser(String userId) async {
    await remoteDataSource.deleteUser(userId);
    return true;
  }

  @override
  Future<List<CicloModel>> getCycles() async => (await remoteDataSource.getCycles())
      .map(CicloModel.fromJson)
      .toList();

  @override
  Future<bool> createCycle(CicloModel cycle) async {
    await remoteDataSource.createCycle(cycle.toJson());
    return true;
  }

  @override
  Future<bool> updateCycle(CicloModel cycle) async {
    await remoteDataSource.updateCycle(cycle.id, cycle.toJson());
    return true;
  }

  @override
  Future<List<ParaleloModel>> getParallels() async =>
      (await remoteDataSource.getParallels()).map(ParaleloModel.fromJson).toList();

  @override
  Future<bool> createParallel(ParaleloModel parallel) async {
    await remoteDataSource.createParallel(parallel.toJson());
    return true;
  }

  @override
  Future<bool> updateParallel(ParaleloModel parallel) async {
    await remoteDataSource.updateParallel(parallel.id, parallel.toJson());
    return true;
  }

  @override
  Future<List<CarreraModel>> getCareers() async =>
      (await remoteDataSource.getCareers()).map(CarreraModel.fromJson).toList();

  @override
  Future<bool> createCareer(CarreraModel career) async {
    await remoteDataSource.createCareer(career.toJson());
    return true;
  }

  @override
  Future<List<PeriodoModel>> getPeriods() async =>
      (await remoteDataSource.getPeriods()).map(PeriodoModel.fromJson).toList();

  @override
  Future<bool> createPeriod(PeriodoModel period) async {
    await remoteDataSource.createPeriod(period.toJson());
    return true;
  }

  @override
  Future<bool> updatePeriod(PeriodoModel period) async {
    await remoteDataSource.updatePeriod(period.id, period.toJson());
    return true;
  }

  @override
  Future<List<ConfiguracionPeriodoCarreraModel>>
      getConfiguracionPeriodoCarreraModels() async =>
          (await remoteDataSource.getCareerPeriodConfigurations())
              .map(ConfiguracionPeriodoCarreraModel.fromJson)
              .toList();

  @override
  Future<bool> saveConfiguracionPeriodoCarreraModel(
    ConfiguracionPeriodoCarreraModel config,
  ) async {
    await remoteDataSource.saveCareerPeriodConfiguration(config.toJson());
    return true;
  }

  @override
  Future<List<RegistroPracticaModel>> getPracticeLogs() async =>
      (await remoteDataSource.getPracticeLogs())
          .map(RegistroPracticaModel.fromJson)
          .toList();
}