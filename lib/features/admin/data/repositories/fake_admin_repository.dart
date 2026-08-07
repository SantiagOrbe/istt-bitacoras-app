import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/drawer_item_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/practice_log_model.dart';


List<DrawerSectionModel> getAdminDrawerSections() {
  return const [
    DrawerSectionModel(
      title: 'Panel de Control',
      items: [
        DrawerItemModel(
          icon: Icons.dashboard_outlined,
          title: 'Inicio Administrador',
          route: AppRoutes.adminHome,
        ),
        DrawerItemModel(
          icon: Icons.people_outline,
          title: 'Gestión de Usuarios',
          route: AppRoutes.userManagement,
        ),
        DrawerItemModel(
          icon: Icons.school_outlined,
          title: 'Gestión de Carreras',
          route: AppRoutes.careerManagement,
        ),
        DrawerItemModel(
          icon: Icons.calendar_month_outlined,
          title: 'Periodos Lectivos',
          route: AppRoutes.periodManagement,
        ),
        DrawerItemModel(
          icon: Icons.layers_outlined,
          title: 'Ciclos / Cursos',
          route: AppRoutes.cycleManagement,
        ),
        DrawerItemModel(
          icon: Icons.grid_view_outlined,
          title: 'Paralelos y Jornadas',
          route: AppRoutes.parallelManagement,
        ),
        DrawerItemModel(
          icon: Icons.settings_suggest_outlined,
          title: 'Config. Carrera - Periodo',
          route: AppRoutes.careerPeriod,
        ),
      ],
    ),
    DrawerSectionModel(
      title: 'Auditoría y Prácticas',
      items: [
        DrawerItemModel(
          icon: Icons.assignment_turned_in_outlined,
          title: 'Registro de Bitácoras',
          route: AppRoutes.adminPracticeLogs,
        ),
      ],
    ),
  ];
}

class FakeAdminRepository implements IAdminRepository {
  // Simulación de respuesta de red (300ms)
  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // --- Datos Mock en memoria ---
  final List<UserModel> _mockUsers = [
    const UserModel(
      id: '1',
      name: 'Santiago Orbe',
      email: 'santiago@ejemplo.com',
      cedula: '1500123456',
      role: UserRole.student,
      isActive: true,
      company: 'Tech Solutions',
      careerName: 'Desarrollo de Software',
    ),
    const UserModel(
      id: '2',
      name: 'Juan Pérez',
      email: 'juan.perez@ejemplo.com',
      cedula: '1500654321',
      role: UserRole.teacher,
      isActive: true,
    ),
    const UserModel(
      id: '3',
      name: 'María López',
      email: 'maria.lopez@ejemplo.com',
      cedula: '1500987654',
      role: UserRole.academicTutor,
      isActive: true,
    ),
    const UserModel(
      id: '4',
      name: 'Ana Morales',
      email: 'ana.morales@ejemplo.com',
      cedula: '1500112233',
      role: UserRole.admin,
      isActive: true,
    ),
  ];

  final List<CycleModel> _mockCycles = [
    const CycleModel(
      id: 'cyc_1',
      name: 'Primer Semestre',
      level: 1,
      isActive: true,
    ),
    const CycleModel(
      id: 'cyc_2',
      name: 'Segundo Semestre',
      level: 2,
      isActive: true,
    ),
    const CycleModel(
      id: 'cyc_3',
      name: 'Tercer Semestre',
      level: 3,
      isActive: true,
    ),
  ];

  final List<ParallelModel> _mockParallels = [
    const ParallelModel(
      id: 'par_1',
      cycleId: 'cyc_1',
      name: 'A',
      jornada: 'Matutina',
      isActive: true,
    ),
    const ParallelModel(
      id: 'par_2',
      cycleId: 'cyc_1',
      name: 'B',
      jornada: 'Vespertina',
      isActive: true,
    ),
    const ParallelModel(
      id: 'par_3',
      cycleId: 'cyc_2',
      name: 'A',
      jornada: 'Matutina',
      isActive: false,
    ),
  ];

  final List<CareerModel> _mockCareers = [
    const CareerModel(
      id: 'car_1',
      name: 'Desarrollo de Software',
      code: 'DSW',
      shortName: 'DS',
      description: 'Formación orientada al desarrollo de soluciones digitales.',
      modality: 'Presencial',
      isActive: true,
      totalSemesters: 5,
    ),
    const CareerModel(
      id: 'car_2',
      name: 'Administración',
      code: 'ADM',
      shortName: 'ADM',
      description: 'Carrera enfocada en gestión organizacional y procesos.',
      modality: 'Presencial',
      isActive: true,
      totalSemesters: 5,
    ),
    const CareerModel(
      id: 'car_3',
      name: 'Enfermería',
      code: 'ENF',
      shortName: 'ENF',
      description: 'Formación técnica para el cuidado integral de pacientes.',
      modality: 'Presencial',
      isActive: true,
      totalSemesters: 5,
    ),
  ];

  final List<PeriodModel> _mockPeriods = [
    PeriodModel(
      id: 'per_1',
      name: 'Mayo 2026 - Octubre 2026',
      startDate: DateTime(2026, 5, 1),
      endDate: DateTime(2026, 10, 31),
      isActive: true,
    ),
    PeriodModel(
      id: 'per_2',
      name: 'Noviembre 2025 - Abril 2026',
      startDate: DateTime(2025, 11, 1),
      endDate: DateTime(2026, 4, 30),
      isActive: false,
    ),
  ];

  final List<PracticeLogModel> _mockLogs = [
    const PracticeLogModel(
      id: 'log_1',
      studentId: '1',
      studentName: 'Santiago Orbe',
      companyName: 'Tech Solutions',
      date: '2026-08-05',
      entryTime: '08:00 AM',
      exitTime: '12:00 PM',
      activityDescription: 'Configuración e integración de endpoints en Django REST framework.',
      status: 'Aprobado',
    ),
    const PracticeLogModel(
      id: 'log_2',
      studentId: '1',
      studentName: 'Santiago Orbe',
      companyName: 'Tech Solutions',
      date: '2026-08-06',
      entryTime: '08:15 AM',
      exitTime: '01:00 PM',
      activityDescription: 'Diseño de pantallas responsive y manejo de estado en Flutter.',
      status: 'Pendiente',
    ),
  ];

  @override
  Future<List<PracticeLogModel>> getPracticeLogs() async {
    await _delay();
    return List.from(_mockLogs);
  }

  final List<CareerPeriodConfig> _mockConfigs = [
    const CareerPeriodConfig(
      careerId: 'car_1',
      periodId: 'per_1',
      activeSemestersForPractices: [4, 5],
    ),
  ];

  // --- Gestión de Usuarios ---
  @override
  Future<List<UserModel>> getUsers() async {
    await _delay();
    return List.from(_mockUsers);
  }

  @override
  Future<bool> createUser(UserModel user) async {
    await _delay();
    _mockUsers.add(user);
    return true;
  }

  @override
  Future<bool> updateUser(UserModel user) async {
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

  // --- Gestión de Cursos / Ciclos ---
  @override
  Future<List<CycleModel>> getCycles() async {
    await _delay();
    return List.from(_mockCycles);
  }

  @override
  Future<bool> createCycle(CycleModel cycle) async {
    await _delay();
    _mockCycles.add(cycle);
    return true;
  }

  @override
  Future<bool> updateCycle(CycleModel cycle) async {
    await _delay();
    final index = _mockCycles.indexWhere((c) => c.id == cycle.id);
    if (index != -1) {
      _mockCycles[index] = cycle;
      return true;
    }
    return false;
  }

  // --- Gestión de Paralelos ---
  @override
  Future<List<ParallelModel>> getParallels() async {
    await _delay();
    return List.from(_mockParallels);
  }

  @override
  Future<bool> createParallel(ParallelModel parallel) async {
    await _delay();
    _mockParallels.add(parallel);
    return true;
  }

  @override
  Future<bool> updateParallel(ParallelModel parallel) async {
    await _delay();
    final index = _mockParallels.indexWhere((p) => p.id == parallel.id);
    if (index != -1) {
      _mockParallels[index] = parallel;
      return true;
    }
    return false;
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

  @override
  Future<bool> updatePeriod(PeriodModel period) async {
    await _delay();
    final index = _mockPeriods.indexWhere((p) => p.id == period.id);
    if (index != -1) {
      _mockPeriods[index] = period;
      return true;
    }
    return false;
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

