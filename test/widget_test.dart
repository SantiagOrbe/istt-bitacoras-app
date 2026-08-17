// Smoke test de la aplicación principal.

import 'package:flutter_test/flutter_test.dart';

import 'package:bitacoras_app/main.dart';

void main() {
  testWidgets('La app construye el splash inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const BitacorasApp());

    // Deja que el timer del SplashScreen (2s) dispare sin quedarse pendiente.
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(BitacorasApp), findsOneWidget);
  });
}