import 'package:flutter/material.dart';
import '../../domain/models/student_assignment_model.dart';
import '../../domain/repositories/i_responsable_practicas_repository.dart';

class StudentAssignmentController extends ChangeNotifier {
  final IResponsablePracticasRepository repository;

  StudentAssignmentController({required this.repository});

  List<StudentAssignmentModel> _assignments = [];
  bool _isLoading = false;
  bool _pendingOnlyFilter = false;
  String _searchQuery = '';
  String? _errorMessage;

  List<StudentAssignmentModel> get assignments => _assignments;
  bool get isLoading => _isLoading;
  bool get pendingOnlyFilter => _pendingOnlyFilter;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;

  Future<void> loadAssignments() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _assignments = await repository.getStudentAssignments(
        query: _searchQuery,
        pendingOnly: _pendingOnlyFilter ? true : null,
      );
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