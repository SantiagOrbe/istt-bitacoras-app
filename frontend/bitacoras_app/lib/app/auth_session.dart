import 'package:flutter/foundation.dart';

import '../features/inicio/domain/models/usuario_model.dart';

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
