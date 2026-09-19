import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/core/network/api_client.dart';

class GestionCicloController extends ChangeNotifier {
  final IAdminRepository repository;

  GestionCicloController({required this.repository});

  final List<CicloModel> _cycles = [];
  final List<CarreraModel> _careers = [];
  String _searchQuery = '';
  String? _careerId;
  String _statusFilter = 'all';
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<CicloModel> get cycles => List.unmodifiable(_cycles);
  List<CarreraModel> get careers => List.unmodifiable(_careers);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get searchQuery => _searchQuery;
  String? get careerId => _careerId;
  String get careerName => _careers
      .firstWhere(
        (career) => career.id == _careerId,
        orElse: () => const CarreraModel(
          id: '',
          name: 'Todas las carreras',
          code: '',
          shortName: '',
          description: '',
          modality: '',
          isActive: true,
          totalSemesters: 0,
        ),
      )
      .name;

  String get statusFilter => _statusFilter;

  List<CicloModel> get filteredCycles {
    var result = cycles;

    if (_statusFilter == 'active') {
      result = result.where((cycle) => cycle.isActive).toList();
    } else if (_statusFilter == 'inactive') {
      result = result.where((cycle) => !cycle.isActive).toList();
    }

    if (_searchQuery.isEmpty) {
      return result;
    }

    final query = _searchQuery.toLowerCase();
    return result.where((cycle) {
      return cycle.name.toLowerCase().contains(query) ||
          cycle.level.toString().contains(query);
    }).toList();
  }

  Future<void> loadCycles({String? careerId}) async {
    _careerId = careerId ?? _careerId;
    _setLoading(true);
    _clearMessages();

    try {
      final loadedCareers = await repository.getCareers();
      _careers
        ..clear()
        ..addAll(loadedCareers);
      final loadedCycles = await repository.getCycles(careerId: _careerId);
      _cycles
        ..clear()
        ..addAll(loadedCycles);
    } catch (error) {
      _errorMessage = error is ApiException
          ? error.message
          : 'No se pudieron cargar los semestres.';
    } finally {
      _setLoading(false);
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setStatusFilter(String value) {
    _statusFilter = value;
    notifyListeners();
  }

  Future<bool> saveCycle({
    required String? cycleId,
    required String careerId,
    required String name,
    required int level,
    required int hoursPracticas,
    required bool isActive,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      final normalizedName = name.trim();
      if (normalizedName.isEmpty) {
        _errorMessage = 'El nombre del semestre es obligatorio.';
        return false;
      }

      if (level <= 0) {
        _errorMessage = 'El nivel debe ser mayor que cero.';
        return false;
      }

      if (hoursPracticas < 0) {
        _errorMessage = 'Las horas de prácticas no pueden ser negativas.';
        return false;
      }

      if (careerId.isEmpty) {
        _errorMessage = 'Selecciona una carrera.';
        return false;
      }

      final career = _careers.cast<CarreraModel?>().firstWhere(
        (item) => item?.id == careerId,
        orElse: () => null,
      );
      if (career == null) {
        _errorMessage = 'La carrera seleccionada no es válida.';
        return false;
      }
      if (level > career.totalSemesters) {
        _errorMessage =
            'El nivel no puede superar los ${career.totalSemesters} semestres configurados.';
        return false;
      }

      final duplicate = _cycles.any((semester) {
        if (semester.id == cycleId) return false;
        return semester.level == level ||
            semester.name.trim().toLowerCase() == normalizedName.toLowerCase();
      });
      if (duplicate) {
        _errorMessage =
            'El nivel o nombre del semestre ya existe en esta carrera.';
        return false;
      }

      final cycle = CicloModel(
        id: cycleId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        careerId: careerId,
        name: normalizedName,
        level: level,
        hoursPracticas: hoursPracticas,
        isActive: isActive,
      );

      final success = cycleId == null
          ? await repository.createCycle(cycle)
          : await repository.updateCycle(cycle);

      if (!success) {
        _errorMessage = cycleId == null
            ? 'No se pudo crear el semestre.'
            : 'No se pudo actualizar el semestre.';
        return false;
      }

      await loadCycles(careerId: _careerId);
      _successMessage = cycleId == null
          ? 'Semestre creado correctamente.'
          : 'Semestre actualizado correctamente.';
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error is ApiException
          ? error.message
          : 'Ocurrió un error al guardar el curso.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleStatus(CicloModel cycle) async {
    return saveCycle(
      cycleId: cycle.id,
      careerId: cycle.careerId,
      name: cycle.name,
      level: cycle.level,
      hoursPracticas: cycle.hoursPracticas,
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
