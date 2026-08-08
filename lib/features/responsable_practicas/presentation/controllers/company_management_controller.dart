import 'package:flutter/material.dart';
import '../../domain/models/company_model.dart';
import '../../domain/repositories/i_responsable_practicas_repository.dart';

class CompanyManagementController extends ChangeNotifier {
  final IResponsablePracticasRepository repository;

  CompanyManagementController({required this.repository});

  List<CompanyModel> _companies = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _errorMessage;

  List<CompanyModel> get companies => _companies;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;

  Future<void> loadCompanies() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _companies = await repository.getCompanies(query: _searchQuery);
    } catch (e) {
      _errorMessage = 'Error al cargar el listado de empresas';
    } finally {
      _setLoading(false);
    }
  }

  void searchCompanies(String query) {
    _searchQuery = query;
    loadCompanies();
  }

  Future<bool> saveCompany(CompanyModel company) async {
    _setLoading(true);
    try {
      final success = await repository.saveCompany(company);
      if (success) {
        await loadCompanies();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error al guardar la empresa';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleCompanyActiveStatus(String id, bool isActive) async {
    _setLoading(true);
    try {
      final success = await repository.toggleCompanyActiveStatus(id, isActive);
      if (success) {
        await loadCompanies();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error al cambiar el estado de la empresa';
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