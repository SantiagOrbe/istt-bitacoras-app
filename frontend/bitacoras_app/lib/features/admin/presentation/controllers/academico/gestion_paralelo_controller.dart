import 'package:bitacoras_app/app/apps.dart';

class GestionParaleloController extends ChangeNotifier {
  final IAdminRepository repository;

  GestionParaleloController({required this.repository});

  final List<CicloModel> _cycles = [];
  final List<ParaleloModel> _parallels = [];
  String _searchQuery = '';
  String? _selectedCycleId;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<CicloModel> get cycles => List.unmodifiable(_cycles);
  List<ParaleloModel> get parallels => List.unmodifiable(_parallels);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get searchQuery => _searchQuery;
  String? get selectedCycleId => _selectedCycleId;

  List<ParaleloModel> get filteredParallels {
    var result = parallels;

    if (_selectedCycleId != null && _selectedCycleId!.isNotEmpty) {
      result = result.where((parallel) => parallel.cycleId == _selectedCycleId).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((parallel) {
        return parallel.name.toLowerCase().contains(query) ||
            parallel.jornada.toLowerCase().contains(query) ||
            getCycleName(parallel.cycleId).toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  Future<void> loadData() async {
    _setLoading(true);
    _clearMessages();

    try {
      final loadedCycles = await repository.getCycles();
      final loadedParallels = await repository.getParallels();

      _cycles
        ..clear()
        ..addAll(loadedCycles);

      _parallels
        ..clear()
        ..addAll(loadedParallels);

      _selectedCycleId ??= _cycles.isNotEmpty ? _cycles.first.id : null;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los paralelos.';
    } finally {
      _setLoading(false);
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setSelectedCycle(String? cycleId) {
    _selectedCycleId = cycleId;
    notifyListeners();
  }

  String getCycleName(String cycleId) {
    return _cycles.firstWhere(
      (cycle) => cycle.id == cycleId,
      orElse: () => const CicloModel(id: '', name: '', level: 0),
    ).name;
  }

  Future<bool> saveParallel({
    required String? parallelId,
    required String cycleId,
    required String name,
    required String jornada,
    required bool isActive,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      if (cycleId.isEmpty) {
        _errorMessage = 'Selecciona un curso.';
        return false;
      }

      final normalizedName = name.trim();
      if (normalizedName.isEmpty) {
        _errorMessage = 'El nombre del paralelo es obligatorio.';
        return false;
      }

      final normalizedJornada = jornada.trim();
      if (normalizedJornada.isEmpty) {
        _errorMessage = 'La jornada es obligatoria.';
        return false;
      }

      final parallel = ParaleloModel(
        id: parallelId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        cycleId: cycleId,
        name: normalizedName,
        jornada: normalizedJornada,
        isActive: isActive,
      );

      final success = parallelId == null
          ? await repository.createParallel(parallel)
          : await repository.updateParallel(parallel);

      if (!success) {
        _errorMessage = parallelId == null
            ? 'No se pudo crear el paralelo.'
            : 'No se pudo actualizar el paralelo.';
        return false;
      }

      await loadData();
      _successMessage = parallelId == null
          ? 'Paralelo creado correctamente.'
          : 'Paralelo actualizado correctamente.';
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'Ocurrió un error al guardar el paralelo.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleStatus(ParaleloModel parallel) async {
    return saveParallel(
      parallelId: parallel.id,
      cycleId: parallel.cycleId,
      name: parallel.name,
      jornada: parallel.jornada,
      isActive: !parallel.isActive,
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
