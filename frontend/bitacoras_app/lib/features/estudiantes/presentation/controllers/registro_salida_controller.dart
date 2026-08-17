import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';

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

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _company = await repository.getAssignedCompanyLocation();
    _currentRecord = await repository.getCurrentRecord();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> confirmExit() async {
    if (_company == null) return false;

    _isSaving = true;
    notifyListeners();

    final success = await repository.registerAttendance(
      type: 'EXIT',
      latitude: _company!.latitude,
      longitude: _company!.longitude,
    );

    _isSaving = false;
    notifyListeners();

    return success;
  }
}
