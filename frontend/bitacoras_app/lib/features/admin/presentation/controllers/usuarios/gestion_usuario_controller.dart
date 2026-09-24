import 'package:bitacoras_app/features/admin/admin.dart';

class GestionUsuarioController extends ChangeNotifier {
  final IAdminRepository repository;

  GestionUsuarioController({required this.repository});

  List<UsuarioModel> _allUsers = [];
  List<UsuarioModel> filteredUsers = [];
  bool isLoading = true;
  String searchQuery = '';
  bool? activeFilter;
  String? roleFilter;

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    _allUsers = await repository.getUsers();
    applyFilter();

    isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    applyFilter();
    notifyListeners();
  }

  Future<void> setActiveFilter(bool? value) async {
    activeFilter = value;
    await fetchUsers();
  }

  Future<void> setRoleFilter(String? value) async {
    roleFilter = value;
    await fetchUsers();
  }

  void updateUserLocally(UsuarioModel user) {
    final index = _allUsers.indexWhere((item) => item.id == user.id);
    if (index == -1) return;
    _allUsers[index] = user;
    applyFilter();
    notifyListeners();
  }

  void applyFilter() {
    final query = searchQuery.trim().toLowerCase();
    filteredUsers = _allUsers.where((user) {
      final matchesStatus =
          activeFilter == null || user.isActive == activeFilter;
      final matchesRole =
          roleFilter == null || user.role.apiValue == roleFilter;
      final matchesSearch =
          query.isEmpty ||
          user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          (user.cedula?.contains(query) ?? false);
      return matchesStatus && matchesRole && matchesSearch;
    }).toList();
  }

  int get totalUsers => _allUsers.length;

  int get totalStudents =>
      _allUsers.where((user) => user.role == RolUsuarioModel.student).length;

  int get totalTutors => _allUsers.where((user) {
    return user.role == RolUsuarioModel.academicTutor ||
        user.role == RolUsuarioModel.companyTutor;
  }).length;

  int get totalActive => _allUsers.where((user) => user.isActive).length;
}
