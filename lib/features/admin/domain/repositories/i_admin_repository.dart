import '../models/career_model.dart';
import '../models/career_period_config.dart';
import '../models/period_model.dart';
import '../models/user_managment_model.dart'; // Ajusta el nombre si cambiaste de typo

abstract class IAdminRepository {
  // --- Gestión de Usuarios ---
  Future<List<ManagedUser>> getUsers();
  Future<bool> createUser(ManagedUser user);
  Future<bool> updateUser(ManagedUser user);
  Future<bool> deleteUser(String userId);

  // --- Gestión de Carreras ---
  Future<List<CareerModel>> getCareers();
  Future<bool> createCareer(CareerModel career);

  // --- Gestión de Periodos Lectivos ---
  Future<List<PeriodModel>> getPeriods();
  Future<bool> createPeriod(PeriodModel period);

  // --- Configuración Carrera / Periodo ---
  Future<List<CareerPeriodConfig>> getCareerPeriodConfigs();
  Future<bool> saveCareerPeriodConfig(CareerPeriodConfig config);
}