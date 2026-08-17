import 'package:bitacoras_app/app/apps.dart';

class GestionUsuarioController extends ChangeNotifier {
  final IAdminRepository repository;

  GestionUsuarioController({required this.repository});

  List<UsuarioModel> _allUsers = [];
  List<UsuarioModel> filteredUsers = [];
  bool isLoading = true;
  String searchQuery = '';

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

  void applyFilter() {
    if (searchQuery.isEmpty) {
      filteredUsers = List.from(_allUsers);
    } else {
      final query = searchQuery.toLowerCase();
      filteredUsers = _allUsers.where((u) {
        return u.name.toLowerCase().contains(query) ||
            (u.cedula?.contains(query) ?? false);
      }).toList();
    }
  }
}