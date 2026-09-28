import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraPeriodoController extends ChangeNotifier {
  final IAdminRepository repository;

  CarreraPeriodoController({required this.repository});

  List<PeriodoModel> periods = [];
  List<CarreraModel> careers = [];
  final Map<String, Set<int>> selectableSemestersByCareer = {};
  bool isLoading = true;
  String? errorMessage;

  String selectedPeriodId = '';
  final Map<String, Set<int>> configs = {};

  Future<void> loadData({String? initialPeriodId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      periods = await repository.obtenerPeriodos();
      careers = await repository.obtenerCarreras();
      final semesters = await repository.obtenerCiclos();
      final configsList = await repository
          .obtenerConfiguracionesPeriodoCarrera();

      selectableSemestersByCareer.clear();
      for (final semester in semesters.where((item) => item.isActive)) {
        selectableSemestersByCareer
            .putIfAbsent(semester.careerId, () => <int>{})
            .add(semester.level);
      }

      configs.clear();
      for (final config in configsList) {
        final key = '${config.careerId}_${config.periodId}';
        configs[key] = {
          ...configs[key] ?? {},
          ...config.activeSemestersForPractices,
        };
      }

      final activePeriods = periods.where((period) => period.isActive).toList();
      final requestedPeriod = activePeriods.where(
        (period) => period.id == initialPeriodId,
      );
      selectedPeriodId = requestedPeriod.isNotEmpty
          ? requestedPeriod.first.id
          : activePeriods.isNotEmpty
          ? activePeriods.first.id
          : '';
    } catch (_) {
      errorMessage = 'No se pudieron cargar las carreras y periodos.';
    }

    isLoading = false;
    notifyListeners();
  }

  void selectPeriod(String? periodId) {
    if (periodId == null) return;

    final selectedPeriod = periods.firstWhere(
      (period) => period.id == periodId,
      orElse: () => PeriodoModel(
        id: '',
        name: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ),
    );

    if (!selectedPeriod.isActive) return;
    if (periodId != selectedPeriodId) {
      selectedPeriodId = periodId;
      notifyListeners();
    }
  }

  String getConfigKey(String careerId) => '${careerId}_$selectedPeriodId';

  void toggleSemester(String careerId, int semester) {
    final career = careers.firstWhere(
      (item) => item.id == careerId,
      orElse: () => const CarreraModel(
        id: '',
        name: '',
        code: '',
        shortName: '',
        description: '',
        modality: '',
        isActive: false,
        totalSemesters: 0,
      ),
    );
    if (!career.isActive ||
        !(selectableSemestersByCareer[careerId]?.contains(semester) ?? false)) {
      return;
    }

    final key = getConfigKey(careerId);
    final activeSemesters = Set<int>.from(configs[key] ?? {});

    if (activeSemesters.contains(semester)) {
      activeSemesters.remove(semester);
    } else {
      activeSemesters.add(semester);
    }

    configs[key] = activeSemesters;
    notifyListeners();
  }

  Future<bool> saveConfiguration() async {
    if (selectedPeriodId.isEmpty) {
      errorMessage = 'Selecciona un período lectivo antes de guardar.';
      notifyListeners();
      return false;
    }

    try {
      final activeCareers = careers.where((career) => career.isActive);
      final configurations = activeCareers.map((career) {
        final key = getConfigKey(career.id);
        final selectableSemesters =
            selectableSemestersByCareer[career.id] ?? <int>{};
        final activeSemesters = (configs[key] ?? {})
            .where(selectableSemesters.contains)
            .toList()
          ..sort();
        return ConfiguracionPeriodoCarreraModel(
          careerId: career.id,
          periodId: selectedPeriodId,
          activeSemestersForPractices: activeSemesters,
        );
      }).toList();

      await repository.guardarConfiguracionesCarrerasPeriodo(
        selectedPeriodId,
        configurations,
      );
      return true;
    } catch (error) {
      errorMessage = error is ApiException
          ? error.message
          : 'No se pudo guardar la configuración académica.';
      notifyListeners();
      return false;
    }
  }
}
