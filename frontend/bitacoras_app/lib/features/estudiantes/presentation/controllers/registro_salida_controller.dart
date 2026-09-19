import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';
import 'package:geolocator/geolocator.dart';

class RegistroSalidaController extends ChangeNotifier {
  final IAsistenciaRepository repository;

  RegistroSalidaController({required this.repository});

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  UbicacionEmpresaModel? _company;
  UbicacionEmpresaModel? get company => _company;

  RegistroAsistenciaModel? _currentRecord;
  RegistroAsistenciaModel? get currentRecord => _currentRecord;

  bool _isGpsValid = true;
  bool get isGpsValid => _isGpsValid;

  Position? _currentPosition;
  String? _validationMessage;
  String? get validationMessage => _validationMessage;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _company = await repository.getAssignedCompanyLocation();
      _currentRecord = await repository.getCurrentRecord();
      await validateLocation();
    } catch (error) {
      _validationMessage = error.toString();
      _isGpsValid = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> confirmExit() async {
    if (!await validateLocation() || _currentRecord == null) return false;

    _isSaving = true;
    notifyListeners();

    final position = _currentPosition;
    if (position == null) {
      _isSaving = false;
      notifyListeners();
      return false;
    }

    final success = await repository.registerAttendance(
      type: 'EXIT',
      latitude: position.latitude,
      longitude: position.longitude,
    );

    _isSaving = false;
    notifyListeners();

    return success;
  }

  Future<bool> validateLocation() async {
    if (_company == null || _currentRecord == null) {
      _isGpsValid = false;
      _validationMessage = 'No existe una entrada activa para registrar la salida.';
      notifyListeners();
      return false;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      _isGpsValid = false;
      _validationMessage = 'Active el GPS para registrar la salida.';
      notifyListeners();
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _isGpsValid = false;
      _validationMessage = 'Se requieren permisos de ubicación para registrar la salida.';
      notifyListeners();
      return false;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _currentPosition = position;
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _company!.latitude,
        _company!.longitude,
      );
      _isGpsValid = distance <= _company!.allowedRadiusMeters;
      _validationMessage = _isGpsValid
          ? null
          : 'Está fuera del rango permitido para ${_company!.name}.';
    } catch (_) {
      _isGpsValid = false;
      _validationMessage = 'No se pudo verificar la ubicación actual.';
    }
    notifyListeners();
    return _isGpsValid;
  }
}
