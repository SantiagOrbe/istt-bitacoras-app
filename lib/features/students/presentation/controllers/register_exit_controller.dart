import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/students/domain/models/company_location.dart';

class RegisterExitController extends ChangeNotifier {
  final IAttendanceRepository repository;

  RegisterExitController({required this.repository});

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  CompanyLocation? _company;
  CompanyLocation? get company => _company;

  PracticeRecordModel? _currentRecord;
  PracticeRecordModel? get currentRecord => _currentRecord;

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