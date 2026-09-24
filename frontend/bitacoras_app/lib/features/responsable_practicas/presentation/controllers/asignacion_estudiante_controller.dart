import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


class AsignacionEstudianteController extends ChangeNotifier {
  final IResponsablePracticasRepository repository;

  AsignacionEstudianteController({required this.repository});

  List<AsignacionEstudianteModel> _assignments = [];
  bool _isLoading = false;
  bool _pendingOnlyFilter = false;
  String _searchQuery = '';
  String? _errorMessage;
  Map<String, List<Map<String, String>>> _options = {};
  Map<String, List<Map<String, String>>> _hierarchy = {};

  List<AsignacionEstudianteModel> get assignments => _assignments;
  bool get isLoading => _isLoading;
  bool get pendingOnlyFilter => _pendingOnlyFilter;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  List<Map<String, String>> get academicTutors => _options['academicTutors'] ?? [];
  List<Map<String, String>> get companyTutors => _options['companyTutors'] ?? [];
  List<Map<String, String>> get companies => _options['companies'] ?? [];
  List<Map<String, String>> get semesters => _hierarchy['semestres'] ?? [];
  List<Map<String, String>> get parallels => _hierarchy['paralelos'] ?? [];

  Future<void> loadAssignments() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _assignments = await repository.getStudentAssignments(
        query: _searchQuery,
        pendingOnly: _pendingOnlyFilter ? true : null,
      );
      _options = await repository.getAssignmentOptions();
      _hierarchy = await repository.getAcademicHierarchy();
    } catch (e) {
      _errorMessage = 'Error al cargar las asignaciones de estudiantes';
    } finally {
      _setLoading(false);
    }
  }

  void filterByPending(bool pendingOnly) {
    _pendingOnlyFilter = pendingOnly;
    loadAssignments();
  }

  void searchAssignments(String query) {
    _searchQuery = query;
    loadAssignments();
  }

  Future<bool> assignStudent({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  }) async {
    _setLoading(true);
    try {
      final success = await repository.assignStudent(
        assignmentId: assignmentId,
        academicTutorId: academicTutorId,
        companyTutorId: companyTutorId,
        companyId: companyId,
      );

      if (success) {
        await loadAssignments();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error al guardar la asignación del estudiante';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}