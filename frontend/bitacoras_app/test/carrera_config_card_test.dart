import 'package:bitacoras_app/features/admin/admin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('inactive semester is gray and cannot be selected', (
    tester,
  ) async {
    final selectedSemesters = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CarreraConfigCard(
            career: const CarreraModel(
              id: '1',
              name: 'Turismo',
              code: 'TUR',
              shortName: 'TUR',
              description: '',
              modality: 'Presencial',
              isActive: true,
              totalSemesters: 3,
            ),
            activeSemesters: const {1},
            selectableSemesters: const {1, 3},
            onToggleSemester: selectedSemesters.add,
          ),
        ),
      ),
    );

    final inactiveLabel = find.text('2\u00b0 Semestre');
    final inactiveInkWell = tester.widget<InkWell>(
      find.ancestor(of: inactiveLabel, matching: find.byType(InkWell)).first,
    );
    final inactiveChip = tester.widget<AnimatedContainer>(
      find
          .ancestor(
            of: inactiveLabel,
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );

    expect(inactiveInkWell.onTap, isNull);
    expect(
      (inactiveChip.decoration! as BoxDecoration).color,
      AppColores.disabledSurface,
    );
    expect(
      tester.widget<Text>(inactiveLabel).style?.color,
      AppColores.textDisabled,
    );

    await tester.tap(inactiveLabel);
    expect(selectedSemesters, isEmpty);

    await tester.tap(find.text('1\u00b0 Semestre'));
    expect(selectedSemesters, [1]);
  });
}