import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/practice_log_model.dart';


abstract class IAdminRepository {
  // --- Gestión de Usuarios ---
  Future<List<UserModel>> getUsers();
  Future<bool> createUser(UserModel user);
  Future<bool> updateUser(UserModel user);
  Future<bool> deleteUser(String userId);

  // --- Gestión de Cursos / Ciclos ---
  Future<List<CycleModel>> getCycles();
  Future<bool> createCycle(CycleModel cycle);
  Future<bool> updateCycle(CycleModel cycle);

  // --- Gestión de Paralelos ---
  Future<List<ParallelModel>> getParallels();
  Future<bool> createParallel(ParallelModel parallel);
  Future<bool> updateParallel(ParallelModel parallel);

  // --- Gestión de Carreras ---
  Future<List<CareerModel>> getCareers();
  Future<bool> createCareer(CareerModel career);

  // --- Gestión de Periodos Lectivos ---
  Future<List<PeriodModel>> getPeriods();
  Future<bool> createPeriod(PeriodModel period);
  Future<bool> updatePeriod(PeriodModel period);

  // --- Configuración Carrera / Periodo ---
  Future<List<CareerPeriodConfig>> getCareerPeriodConfigs();
  Future<bool> saveCareerPeriodConfig(CareerPeriodConfig config);

  Future<List<PracticeLogModel>> getPracticeLogs();
}