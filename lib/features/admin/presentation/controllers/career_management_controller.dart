import 'package:bitacoras_app/app/apps.dart';

class CareerManagementController extends ChangeNotifier {
  final IAdminRepository repository;

  CareerManagementController({required this.repository});

  final List<CareerModel> _careers = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<CareerModel> get careers => List.unmodifiable(_careers);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<CareerModel> get filteredCareers {
    if (_searchQuery.isEmpty) {
      return careers;
    }

    final query = _searchQuery.toLowerCase();
    return careers.where((career) {
      return career.name.toLowerCase().contains(query);
    }).toList();
  }

  bool get hasCareers => _careers.isNotEmpty;

  Future<void> loadCareers() async {
    _setLoading(true);
    _clearError();

    try {
      _careers
        ..clear()
        ..addAll(await repository.getCareers());
    } catch (error) {
      _errorMessage = 'No se pudieron cargar las carreras.';
    } finally {
      _setLoading(false);
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<bool> createCareer(CareerModel career) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await repository.createCareer(career);
      if (success) {
        await loadCareers();
      }
      return success;
    } catch (error) {
      _errorMessage = 'No se pudo crear la carrera.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
