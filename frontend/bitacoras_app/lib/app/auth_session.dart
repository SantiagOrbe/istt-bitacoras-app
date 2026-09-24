import 'package:bitacoras_app/app/apps.dart';


class AuthSession extends ChangeNotifier {
  UsuarioModel? _currentUser;

  UsuarioModel? get currentUser => _currentUser;

  void setUser(UsuarioModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void restoreUser(UsuarioModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  void clear() {
    _currentUser = null;
    notifyListeners();
  }
}
