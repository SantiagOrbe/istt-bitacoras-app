import 'package:bitacoras_app/features/admin/admin.dart';



class CarreraPeriodoController extends ChangeNotifier {
  final IAdminRepository repository;

  CarreraPeriodoController({required this.repository});

  List<PeriodoModel> periods = [];
  List<CarreraModel> careers = [];
  bool isLoading = true;

  String selectedPeriodId = '';
  final Map<String, Set<int>> configs = {};

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    periods = await repository.getPeriods();
    careers = await repository.getCareers();
    final configsList = await repository.getConfiguracionPeriodoCarreraModels();

    configs.clear();
    for (final config in configsList) {
      final key = '${config.careerId}_${config.periodId}';
      configs[key] = config.activeSemestersForPractices.toSet();
    }

    if (periods.isNotEmpty) {
      selectedPeriodId = periods.first.id;
    }

    isLoading = false;
    notifyListeners();
  }

  void selectPeriod(String? periodId) {
    if (periodId != null && periodId != selectedPeriodId) {
      selectedPeriodId = periodId;
      notifyListeners();
    }
  }

  String getConfigKey(String careerId) => '${careerId}_$selectedPeriodId';

  void toggleSemester(String careerId, int semester) {
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