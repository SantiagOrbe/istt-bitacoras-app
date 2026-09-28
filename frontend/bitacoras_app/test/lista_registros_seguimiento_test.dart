import 'package:bitacoras_app/features/tutores/tutores.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('academic student history shows date and times without actions', (
    tester,
  ) async {
    const log = RegistroPracticaModel(
      id: '1',
      studentId: '2',
      studentName: 'Estudiante de prueba',
      companyName: 'Empresa de prueba',
      date: '2026-09-27',
      entryTime: '08:05:00',
      exitTime: '13:20:00',
      activityDescription: 'Revisión de inventario',
      status: 'Aprobado',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaRegistrosSeguimiento(
            isLoading: false,
            errorMessage: null,
            logs: const [log],
            onRefresh: () async {},
          ),
        ),
      ),
    );

    expect(find.text('FECHA'), findsOneWidget);
    expect(find.text('2026-09-27'), findsOneWidget);
    expect(find.text('8:05 AM'), findsOneWidget);
    expect(find.text('1:20 PM'), findsOneWidget);
    expect(find.text('Revisión de inventario'), findsOneWidget);
    expect(find.text('Aprobado'), findsNothing);
    expect(find.text('En curso'), findsNothing);
    expect(find.byType(PopupMenuButton<String>), findsNothing);
    expect(find.text('Editar'), findsNothing);
    expect(find.text('Desactivar'), findsNothing);
  });

  testWidgets('company tutor record card has no edit menu', (tester) async {
    const log = RegistroPracticaModel(
      id: '2',
      studentId: '3',
      studentName: 'Pasante de prueba',
      companyName: 'Empresa de prueba',
      date: '2026-09-27',
      entryTime: '08:00:00',
      exitTime: '12:00:00',
      activityDescription: 'Apoyo en operaciones',
      status: 'En curso',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RegistroSeguimientoCard(log: log)),
      ),
    );

    expect(find.byType(PopupMenuButton<String>), findsNothing);
    expect(find.text('Pasante de prueba'), findsOneWidget);
  });

  test('company tutor drawer omits the follow-up section', () {
    final items = getOpcionesDrawerTutorEmpresarial().expand(
      (section) => section.items,
    );

    expect(items.any((item) => item.title == 'Seguimiento'), isFalse);
  });
}
