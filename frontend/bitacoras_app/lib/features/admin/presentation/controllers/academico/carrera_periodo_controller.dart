import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraPeriodoController extends ChangeNotifier {
  final IAdminRepository repository;

  CarreraPeriodoController({required this.repository});

  List<PeriodoModel> periods = [];
  List<CarreraModel> careers = [];
  bool isLoading = true;
  String? errorMessage;

  String selectedPeriodId = '';
  final Map<String, Set<int>> configs = {};

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      periods = await repository.getPeriods();
      careers = await repository.getCareers();
      final configsList = await repository
          .getConfiguracionPeriodoCarreraModels();

      configs.clear();
      for (final config in configsList) {
        final key = '${config.careerId}_${config.periodId}';
        configs[key] = {
          ...configs[key] ?? {},
          ...config.activeSemestersForPractices,
        };
      }

      final activePeriods = periods.where((period) => period.isActive).toList();
      if (activePeriods.isNotEmpty) {
        selectedPeriodId = activePeriods.first.id;
      } else {
        selectedPeriodId = '';
      }
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
    if (!career.isActive) {
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
    for (final career in careers) {
      if (!career.isActive) continue;

      final key = getConfigKey(career.id);
      final activeSemesters = configs[key]?.toList() ?? [];

      await repository.saveConfiguracionPeriodoCarreraModel(
        ConfiguracionPeriodoCarreraModel(
          careerId: career.id,
          periodId: selectedPeriodId,
          activeSemestersForPractices: activeSemesters,
        ),
      );
    }
    return true;
  }
}
