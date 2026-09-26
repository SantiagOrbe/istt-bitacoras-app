import 'package:bitacoras_app/features/admin/admin.dart';

class AdminRepositoryImpl implements IAdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UsuarioModel>> obtenerUsuarios({
    bool? isActive,
    String? role,
    String? search,
  }) async => (await remoteDataSource.obtenerUsuarios(
    isActive: isActive,
    role: role,
    search: search,
  )).map(UsuarioModel.fromJson).toList();

  @override
  Future<bool> crearUsuario(UsuarioModel usuario) async {
    await remoteDataSource.crearUsuario(usuario.toJson());
    return true;
  }

  @override
  Future<bool> actualizarUsuario(UsuarioModel usuario) async {
    await remoteDataSource.actualizarUsuario(usuario.id, usuario.toJson());
    return true;
  }

  @override
  Future<bool> cambiarEstadoUsuario(String userId, bool isActive) async {
    await remoteDataSource.cambiarEstadoUsuario(userId, isActive);
    return true;
  }

  @override
  Future<bool> eliminarUsuario(String userId) async {
    await remoteDataSource.eliminarUsuario(userId);
    return true;
  }

  @override
  Future<List<EmpresaModel>> obtenerEmpresas() async =>
      (await remoteDataSource.obtenerEmpresas())
          .map(EmpresaModel.fromJson)
          .toList();

  @override
  Future<bool> crearEmpresa(EmpresaModel empresa) async {
    await remoteDataSource.crearEmpresa(empresa.toJson());
    return true;
  }

  @override
  Future<bool> actualizarEmpresa(EmpresaModel empresa) async {
    await remoteDataSource.actualizarEmpresa(empresa.id, empresa.toJson());
    return true;
  }

  @override
  Future<bool> desactivarEmpresa(
    String companyId, {
    bool unlinkStudents = false,
  }) async {
    await remoteDataSource.desactivarEmpresa(
      companyId,
      unlinkStudents: unlinkStudents,
    );
    return true;
  }

  @override
  Future<List<Map<String, String>>> obtenerEstudiantesVinculadosEmpresa(
    String companyId,
  ) async {
    return await remoteDataSource.obtenerEstudiantesVinculadosEmpresa(
      companyId,
    );
  }

  @override
  Future<List<CicloModel>> obtenerCiclos({String? careerId}) async =>
      (await remoteDataSource.obtenerCiclos(
        careerId: careerId,
      )).map(CicloModel.fromJson).toList();

  @override
  Future<bool> crearCiclo(CicloModel ciclo) async {
    await remoteDataSource.crearCiclo(ciclo.toJson());
    return true;
  }

  @override
  Future<bool> actualizarCiclo(CicloModel ciclo) async {
    await remoteDataSource.actualizarCiclo(ciclo.id, ciclo.toJson());
    return true;
  }

  @override
  Future<List<ParaleloModel>> obtenerParalelos({
    String? careerId,
    String? semesterId,
  }) async => (await remoteDataSource.obtenerParalelos(
    careerId: careerId,
    semesterId: semesterId,
  )).map(ParaleloModel.fromJson).toList();

  @override
  Future<bool> crearParalelo(ParaleloModel paralelo) async {
    await remoteDataSource.crearParalelo(paralelo.toJson());
    return true;
  }

  @override
  Future<bool> actualizarParalelo(ParaleloModel paralelo) async {
    await remoteDataSource.actualizarParalelo(paralelo.id, paralelo.toJson());
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerEstudiantesParalelo(
    String parallelId,
  ) => remoteDataSource.obtenerEstudiantesParalelo(parallelId);

  @override
  Future<bool> asignarEstudiantesParalelo(
    String parallelId,
    List<int> studentIds,
  ) async {
    await remoteDataSource.asignarEstudiantesParalelo(parallelId, studentIds);
    return true;
  }

  @override
  Future<bool> eliminarEstudiantesParalelo(String parallelId) async {
    await remoteDataSource.eliminarEstudiantesParalelo(parallelId);
    return true;
  }

  @override
  Future<List<CarreraModel>> obtenerCarreras() async =>
      (await remoteDataSource.obtenerCarreras())
          .map(CarreraModel.fromJson)
          .toList();

  @override
  Future<bool> crearCarrera(CarreraModel carrera) async {
    await remoteDataSource.crearCarrera(carrera.toJson());
    return true;
  }

  @override
  Future<bool> actualizarCarrera(
    CarreraModel carrera, {
    bool confirmDesactivate = false,
  }) async {
    await remoteDataSource.actualizarCarrera(
      carrera.id,
      carrera.toJson(),
      confirmDesactivate: confirmDesactivate,
    );
    return true;
  }

  @override
  Future<List<PeriodoModel>> obtenerPeriodos() async =>
      (await remoteDataSource.obtenerPeriodos())
          .map(PeriodoModel.fromJson)
          .toList();

  @override
  Future<bool> crearPeriodo(PeriodoModel periodo) async {
    await remoteDataSource.crearPeriodo(periodo.toJson());
    return true;
  }

  @override
  Future<bool> actualizarPeriodo(
    PeriodoModel periodo, {
    bool confirmDesactivate = false,
  }) async {
    await remoteDataSource.actualizarPeriodo(
      periodo.id,
      periodo.toJson(),
      confirmDesactivate: confirmDesactivate,
    );
    return true;
  }

  @override
  Future<List<ConfiguracionPeriodoCarreraModel>>
  obtenerConfiguracionesPeriodoCarrera() async =>
      (await remoteDataSource.obtenerConfiguracionesPeriodoCarrera())
          .map(ConfiguracionPeriodoCarreraModel.fromJson)
          .toList();

  @override
  Future<bool> guardarConfiguracionPeriodoCarrera(
    ConfiguracionPeriodoCarreraModel config,
  ) async {
    await remoteDataSource.guardarConfiguracionPeriodoCarrera(config.toJson());
    return true;
  }

  @override
  Future<bool> guardarConfiguracionesCarrerasPeriodo(
    String periodId,
    List<ConfiguracionPeriodoCarreraModel> configs,
  ) async {
    await remoteDataSource.guardarConfiguracionesCarrerasPeriodo(
      periodId,
      configs.map((config) => {
        'carrera': config.careerId,
        'active_semesters': config.activeSemestersForPractices,
      }).toList(),
    );
    return true;
  }

  @override
  Future<List<RegistroPracticaModel>> obtenerRegistrosPractica() async =>
      (await remoteDataSource.obtenerRegistrosPractica())
          .map(RegistroPracticaModel.fromJson)
          .toList();
}
