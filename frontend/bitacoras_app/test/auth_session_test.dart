import 'package:bitacoras_app/app/auth_session.dart';
import 'package:bitacoras_app/features/inicio/domain/models/rol_usuario_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthSession restores the real logged-in user and clears stale data', () {
    final session = AuthSession();
    const staleUser = UsuarioModel(
      id: '3',
      name: 'María López',
      email: 'maria.lopez@itstena.edu.ec',
      role: RolUsuarioModel.academicTutor,
    );
    const realUser = UsuarioModel(
      id: '11',
      name: 'Jeyson Tapuy',
      email: 'jeyson.tapuy@est.itstena.edu.ec',
      role: RolUsuarioModel.academicTutor,
    );

    session.setUser(staleUser);
    session.restoreUser(realUser);
    expect(session.currentUser, realUser);

    session.clear();
    expect(session.currentUser, isNull);
  });
}
