import 'package:bitacoras_app/app/apps.dart';

class CycleManagementController extends ChangeNotifier {
  final IAdminRepository repository;

  CycleManagementController({required this.repository});

  final List<CycleModel> _cycles = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<CycleModel> get cycles => List.unmodifiable(_cycles);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get searchQuery => _searchQuery;

  List<CycleModel> get filteredCycles {
    if (_searchQuery.isEmpty) {
      return cycles;
    }

    final query = _searchQuery.toLowerCase();
    return cycles.where((cycle) {
      return cycle.name.toLowerCase().contains(query) ||
          cycle.level.toString().contains(query);
    }).toList();
  }

  Future<void> loadCycles() async {
    _setLoading(true);
    _clearMessages();

    try {
      _cycles
        ..clear()
        ..addAll(await repository.getCycles());
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los cursos.';
    } finally {
      _setLoading(false);
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<bool> saveCycle({
    required String? cycleId,
    required String name,
    required int level,
    required bool isActive,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      final normalizedName = name.trim();
      if (normalizedName.isEmpty) {
        _errorMessage = 'El nombre del curso es obligatorio.';
        return false;
      }

      if (level <= 0) {
        _errorMessage = 'El nivel debe ser mayor que cero.';
        return false;
      }

      final cycle = CycleModel(
        id: cycleId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: normalizedName,
        level: level,
        isActive: isActive,
      );

      final success = cycleId == null
          ? await repository.createCycle(cycle)
          : await repository.updateCycle(cycle);

      if (!success) {
        _errorMessage = cycleId == null
            ? 'No se pudo crear el curso.'
            : 'No se pudo actualizar el curso.';
        return false;
      }

      await loadCycles();
      _successMessage = cycleId == null
          ? 'Curso creado correctamente.'
          : 'Curso actualizado correctamente.';
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'Ocurrió un error al guardar el curso.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleStatus(CycleModel cycle) async {
    return saveCycle(
      cycleId: cycle.id,
      name: cycle.name,
      level: cycle.level,
      isActive: !cycle.isActive,
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }
}
