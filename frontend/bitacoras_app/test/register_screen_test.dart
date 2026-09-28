import 'package:bitacoras_app/features/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('duplicate email keeps the user on the registration form', (
    tester,
  ) async {
    final repository = _DuplicateEmailRepository();

    await tester.pumpWidget(
      MaterialApp(home: RegisterScreen(authRepository: repository)),
    );

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'estudiante@est.itstena.edu.ec');
    await tester.enterText(fields.at(1), 'ClaveSegura123');
    await tester.enterText(fields.at(2), 'ClaveSegura123');
    await tester.tap(find.text('REGISTRARME'));
    await tester.pumpAndSettle();

    expect(repository.attemptedEmail, 'estudiante@est.itstena.edu.ec');
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(
      find.text('Este correo electrónico ya está registrado.'),
      findsOneWidget,
    );
  });
}

class _DuplicateEmailRepository implements IAuthRepository {
  String? attemptedEmail;

  @override
  Future<UsuarioModel?> iniciarSesion({
    required String email,
    required String password,
  }) async => null;

  @override
  Future<void> registrarUsuario({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    attemptedEmail = email;
    throw const ApiException(
      statusCode: 400,
      message: 'Datos no válidos.',
      body: {
        'email': ['Este correo electrónico ya está registrado.'],
      },
    );
  }

  @override
  Future<void> cerrarSesion() async {}

  @override
  Future<UsuarioModel?> obtenerUsuarioActual() async => null;
}