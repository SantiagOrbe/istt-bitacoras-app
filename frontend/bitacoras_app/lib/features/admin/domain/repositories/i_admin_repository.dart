import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';


abstract class IAdminRepository {
  // --- Gestión de Usuarios ---
  Future<List<UsuarioModel>> getUsers();
  Future<bool> createUser(UsuarioModel user);
  Future<bool> updateUser(UsuarioModel user);
  Future<bool> deleteUser(String userId);

  // --- Gestión de Cursos / Ciclos ---
  Future<List<CicloModel>> getCycles();
  Future<bool> createCycle(CicloModel cycle);
  Future<bool> updateCycle(CicloModel cycle);

  // --- Gestión de Paralelos ---
  Future<List<ParaleloModel>> getParallels();
  Future<bool> createParallel(ParaleloModel parallel);
  Future<bool> updateParallel(ParaleloModel parallel);

  // --- Gestión de Carreras ---
  Future<List<CarreraModel>> getCareers();
  Future<bool> createCareer(CarreraModel career);

  // --- Gestión de Periodos Lectivos ---
  Future<List<PeriodoModel>> getPeriods();
  Future<bool> createPeriod(PeriodoModel period);
  Future<bool> updatePeriod(PeriodoModel period);

  // --- Configuración Carrera / Periodo ---
  Future<List<ConfiguracionPeriodoCarreraModel>> getConfiguracionPeriodoCarreraModels();
  Future<bool> saveConfiguracionPeriodoCarreraModel(ConfiguracionPeriodoCarreraModel config);

  Future<List<RegistroPracticaModel>> getPracticeLogs();
}