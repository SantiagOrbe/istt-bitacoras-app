import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/empresa_model.dart';
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
  Future<List<UsuarioModel>> getUsers({
    bool? isActive,
    String? role,
    String? search,
  }) async => (await remoteDataSource.getUsers(
    isActive: isActive,
    role: role,
    search: search,
  )).map(UsuarioModel.fromJson).toList();

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
  Future<bool> setUserActive(String userId, bool isActive) async {
    await remoteDataSource.setUserActive(userId, isActive);
    return true;
  }

  @override
  Future<bool> deleteUser(String userId) async {
    await remoteDataSource.deleteUser(userId);
    return true;
  }

  @override
  Future<List<EmpresaModel>> getCompanies() async =>
      (await remoteDataSource.getCompanies())
          .map(EmpresaModel.fromJson)
          .toList();

  @override
  Future<bool> createCompany(EmpresaModel company) async {
    await remoteDataSource.createCompany(company.toJson());
    return true;
  }

  @override
  Future<bool> updateCompany(EmpresaModel company) async {
    await remoteDataSource.updateCompany(company.id, company.toJson());
    return true;
  }

  @override
  Future<bool> deactivateCompany(String companyId) async {
    await remoteDataSource.deactivateCompany(companyId);
    return true;
  }

  @override
  Future<List<CicloModel>> getCycles({String? careerId}) async =>
      (await remoteDataSource.getCycles(
        careerId: careerId,
      )).map(CicloModel.fromJson).toList();

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
  Future<List<ParaleloModel>> getParallels({
    String? careerId,
    String? semesterId,
  }) async => (await remoteDataSource.getParallels(
    careerId: careerId,
    semesterId: semesterId,
  )).map(ParaleloModel.fromJson).toList();

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
  Future<List<Map<String, dynamic>>> getParallelStudents(String parallelId) =>
      remoteDataSource.getParallelStudents(parallelId);

  @override
  Future<bool> assignParallelStudents(
    String parallelId,
    List<int> studentIds,
  ) async {
    await remoteDataSource.assignParallelStudents(parallelId, studentIds);
    return true;
  }

  @override
  Future<bool> removeParallelStudents(String parallelId) async {
    await remoteDataSource.removeParallelStudents(parallelId);
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
  Future<bool> updateCareer(CarreraModel career) async {
    await remoteDataSource.updateCareer(career.id, career.toJson());
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
