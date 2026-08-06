import '../../domain/models/career_model.dart';
import '../../domain/models/career_period_config.dart';
import '../../domain/models/period_model.dart';
import '../../domain/models/user_managment_model.dart';
import '../../domain/repositories/i_admin_repository.dart';

class FakeAdminRepository implements IAdminRepository {
  // Simulación de respuesta de red (300ms)
  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // --- Datos Mock en memoria ---
  final List<ManagedUser> _mockUsers = [
    const ManagedUser(
      id: '1',
      name: 'Santiago Orbe',
      idNumber: '1500123456',
      role: 'Estudiante',
      isActive: true,
    ),
    const ManagedUser(
      id: '2',
      name: 'Juan Pérez',
      idNumber: '1500654321',
      role: 'Docente',
      isActive: true,
    ),
    const ManagedUser(
      id: '3',
      name: 'María López',
      idNumber: '1500987654',
      role: 'Tutor Académico',
      isActive: true,
    ),
    const ManagedUser(
      id: '4',
      name: 'Ana Morales',
      idNumber: '1500112233',
      role: 'Coordinador',
      isActive: true,
    ),
  ];

  final List<CareerModel> _mockCareers = [
    const CareerModel(
      id: 'car_1',
      name: 'Desarrollo de Software',
      totalSemesters: 5,
    ),
    const CareerModel(
      id: 'car_2',
      name: 'Administración',
      totalSemesters: 5,
    ),
    const CareerModel(
      id: 'car_3',
      name: 'Enfermería',
      totalSemesters: 5,
    ),
  ];

  final List<PeriodModel> _mockPeriods = [
    const PeriodModel(
      id: 'per_1',
      name: 'Mayo 2026 - Octubre 2026',
      isActive: true,
    ),
    const PeriodModel(
      id: 'per_2',
      name: 'Noviembre 2025 - Abril 2026',
      isActive: false,
    ),
  ];

  final List<CareerPeriodConfig> _mockConfigs = [
    const CareerPeriodConfig(
      careerId: 'car_1',
      periodId: 'per_1',
      activeSemestersForPractices: [4, 5],
    ),
  ];

  // --- Gestión de Usuarios ---
  @override
  Future<List<ManagedUser>> getUsers() async {
    await _delay();
    return List.from(_mockUsers);
  }

  @override
  Future<bool> createUser(ManagedUser user) async {
    await _delay();
    _mockUsers.add(user);
    return true;
  }

  @override
  Future<bool> updateUser(ManagedUser user) async {
    await _delay();
    final index = _mockUsers.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _mockUsers[index] = user;
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteUser(String userId) async {
    await _delay();
    _mockUsers.removeWhere((u) => u.id == userId);
    return true;
  }

  // --- Gestión de Carreras ---
  @override
  Future<List<CareerModel>> getCareers() async {
    await _delay();
    return List.from(_mockCareers);
  }

  @override
  Future<bool> createCareer(CareerModel career) async {
    await _delay();
    _mockCareers.add(career);
    return true;
  }

  // --- Gestión de Periodos Lectivos ---
  @override
  Future<List<PeriodModel>> getPeriods() async {
    await _delay();
    return List.from(_mockPeriods);
  }

  @override
  Future<bool> createPeriod(PeriodModel period) async {
    await _delay();
    _mockPeriods.add(period);
    return true;
  }

  // --- Configuración Carrera / Periodo ---
  @override
  Future<List<CareerPeriodConfig>> getCareerPeriodConfigs() async {
    await _delay();
    return List.from(_mockConfigs);
  }

  @override
  Future<bool> saveCareerPeriodConfig(CareerPeriodConfig config) async {
    await _delay();
    final index = _mockConfigs.indexWhere(
      (c) => c.careerId == config.careerId && c.periodId == config.periodId,
    );
    if (index != -1) {
      _mockConfigs[index] = config;
    } else {
      _mockConfigs.add(config);
    }
    return true;
  }
}