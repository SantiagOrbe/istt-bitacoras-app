import 'package:bitacoras_app/app/apps.dart';

abstract class IAdminRepository {
  // --- Gestión de Usuarios ---
  Future<List<UsuarioModel>> getUsers({
    bool? isActive,
    String? role,
    String? search,
  });
  Future<bool> createUser(UsuarioModel user);
  Future<bool> updateUser(UsuarioModel user);
  Future<bool> setUserActive(String userId, bool isActive);
  Future<bool> deleteUser(String userId);

  Future<List<EmpresaModel>> getCompanies();
  Future<bool> createCompany(EmpresaModel company);
  Future<bool> updateCompany(EmpresaModel company);
  Future<bool> deactivateCompany(String companyId);

  // --- Gestión de Cursos / Ciclos ---
  Future<List<CicloModel>> getCycles({String? careerId});
  Future<bool> createCycle(CicloModel cycle);
  Future<bool> updateCycle(CicloModel cycle);

  // --- Gestión de Paralelos ---
  Future<List<ParaleloModel>> getParallels({
    String? careerId,
    String? semesterId,
  });
  Future<bool> createParallel(ParaleloModel parallel);
  Future<bool> updateParallel(ParaleloModel parallel);

  // --- Gestión de Carreras ---
  Future<List<CarreraModel>> getCareers();
  Future<bool> createCareer(CarreraModel career);
  Future<bool> updateCareer(CarreraModel career);

  // --- Gestión de Periodos Lectivos ---
  Future<List<PeriodoModel>> getPeriods();
  Future<bool> createPeriod(PeriodoModel period);
  Future<bool> updatePeriod(PeriodoModel period);

  // --- Configuración Carrera / Periodo ---
  Future<List<ConfiguracionPeriodoCarreraModel>>
  getConfiguracionPeriodoCarreraModels();
  Future<bool> saveConfiguracionPeriodoCarreraModel(
    ConfiguracionPeriodoCarreraModel config,
  );

  Future<List<RegistroPracticaModel>> getPracticeLogs();
}
