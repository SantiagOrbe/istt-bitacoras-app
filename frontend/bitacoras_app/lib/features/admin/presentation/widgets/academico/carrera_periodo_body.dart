import 'package:bitacoras_app/features/admin/admin.dart';


class CarreraPeriodoBody extends StatelessWidget {
  final List<PeriodoModel> periods;
  final List<CarreraModel> careers;
  final String selectedPeriodId;
  final Map<String, Set<int>> configs;
  final String Function(String) getConfigKey;
  final ValueChanged<String?> onPeriodChanged;
  final void Function(String, int) onToggleSemester;

  const CarreraPeriodoBody({
    super.key,
    required this.periods,
    required this.careers,
    required this.selectedPeriodId,
    required this.configs,
    required this.getConfigKey,
    required this.onPeriodChanged,
    required this.onToggleSemester,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminHeader(
          title: 'Carreras y Periodos',
          subtitle:
              'Habilita los semestres que realizan prácticas preprofesionales en cada periodo lectivo.',
        ),
        PeriodoSelectorCard(
          periods: periods,
          selectedPeriodId: selectedPeriodId,
          onChanged: onPeriodChanged,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: careers.length,
            itemBuilder: (context, index) {
              final career = careers[index];
              final key = getConfigKey(career.id);

              return CarreraConfigCard(
                career: career,
                activeSemesters: configs[key] ?? {},
                onToggleSemester: (semester) =>
                    onToggleSemester(career.id, semester),
              );
            },
          ),
        ),
      ],
    );
  }
}