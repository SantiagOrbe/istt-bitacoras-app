import 'package:bitacoras_app/app/apps.dart';

class GestionPeriodoController extends ChangeNotifier {
  final IAdminRepository repository;

  GestionPeriodoController({required this.repository});

  final List<PeriodoModel> _periods = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<PeriodoModel> get periods => List.unmodifiable(_periods);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get searchQuery => _searchQuery;

  List<PeriodoModel> get filteredPeriods {
    if (_searchQuery.isEmpty) {
      return periods;
    }

    final query = _searchQuery.toLowerCase();
    return periods.where((period) {
      return period.name.toLowerCase().contains(query);
    }).toList();
  }

  bool get hasPeriods => _periods.isNotEmpty;

  Future<void> loadPeriods() async {
    _setLoading(true);
    _clearMessages();

    try {
      _periods
        ..clear()
        ..addAll(await repository.getPeriods());
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los períodos lectivos.';
    } finally {
      _setLoading(false);
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<bool> savePeriod({
    required String? periodId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      final normalizedName = name.trim();
      if (normalizedName.isEmpty) {
        _errorMessage = 'El nombre del período es obligatorio.';
        return false;
      }

      if (endDate.isBefore(startDate)) {
        _errorMessage = 'La fecha fin no puede ser menor que la fecha de inicio.';
        return false;
      }

      final overlappingPeriod = _periods.any((period) {
        if (periodId != null && period.id == periodId) {
          return false;
        }

        return _datesOverlap(
          startDate,
          endDate,
          period.startDate,
          period.endDate,
        );
      });

      if (overlappingPeriod) {
        _errorMessage = 'El período se traslapa con uno ya existente.';
        return false;
      }

      final id = periodId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final period = PeriodoModel(
        id: id,
        name: normalizedName,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive,
      );

      if (periodId == null) {
        final created = await repository.createPeriod(period);
        if (!created) {
          _errorMessage = 'No se pudo crear el período lectivo.';
          return false;
        }
      } else {
        final updated = await repository.updatePeriod(period);
        if (!updated) {
          _errorMessage = 'No se pudo actualizar el período lectivo.';
          return false;
        }
      }

      await _syncActiveState(period);
      await loadPeriods();
      _successMessage = periodId == null
          ? 'Período lectivo creado correctamente.'
          : 'Período lectivo actualizado correctamente.';
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'Ocurrió un error al guardar el período lectivo.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deactivatePeriod(PeriodoModel period) async {
    if (!period.isActive) {
      return true;
    }

    return savePeriod(
      periodId: period.id,
      name: period.name,
      startDate: period.startDate,
      endDate: period.endDate,
      isActive: false,
    );
  }

  Future<bool> activatePeriod(PeriodoModel period) async {
    return savePeriod(
      periodId: period.id,
      name: period.name,
      startDate: period.startDate,
      endDate: period.endDate,
      isActive: true,
    );
  }

  Future<void> _syncActiveState(PeriodoModel targetPeriod) async {
    if (!targetPeriod.isActive) {
      return;
    }

    final activePeriods = _periods
        .where((period) => period.isActive && period.id != targetPeriod.id)
        .toList();

    for (final activePeriod in activePeriods) {
      final updated = activePeriod.copyWith(isActive: false);
      await repository.updatePeriod(updated);
    }
  }

  bool _datesOverlap(
    DateTime startA,
    DateTime endA,
    DateTime startB,
    DateTime endB,
  ) {
    return startA.isBefore(endB.add(const Duration(days: 1))) &&
        startB.isBefore(endA.add(const Duration(days: 1)));
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
