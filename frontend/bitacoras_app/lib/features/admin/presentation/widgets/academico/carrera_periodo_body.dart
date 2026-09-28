import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraPeriodoBody extends StatelessWidget {
  final List<PeriodoModel> periods;
  final List<CarreraModel> careers;
  final Map<String, Set<int>> selectableSemestersByCareer;
  final String selectedPeriodId;
  final Map<String, Set<int>> configs;
  final String Function(String) getConfigKey;
  final ValueChanged<String?> onPeriodChanged;
  final void Function(String, int) onToggleSemester;

  const CarreraPeriodoBody({
    super.key,
    required this.periods,
    required this.careers,
    required this.selectableSemestersByCareer,
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
        Container(
          margin: const EdgeInsets.fromLTRB(
            AppTamanos.md,
            AppTamanos.sm,
            AppTamanos.md,
            0,
          ),
          padding: const EdgeInsets.all(AppTamanos.md),
          decoration: BoxDecoration(
            color: AppColores.surface,
            borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
            border: Border.all(color: AppColores.outline),
            boxShadow: [
              BoxShadow(
                color: AppColores.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColores.secondary, AppColores.warning],
                  ),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColores.surface,
                ),
              ),
              AppTamanos.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Carreras y períodos', style: AppEstiloTexto.title),
                    Text(
                      'Habilita semestres para prácticas preprofesionales.',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PeriodoSelectorCard(
          periods: periods,
          selectedPeriodId: selectedPeriodId,
          onChanged: onPeriodChanged,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppTamanos.md),
            itemCount: careers.length,
            itemBuilder: (context, index) {
              final career = careers[index];
              final key = getConfigKey(career.id);

              return CarreraConfigCard(
                career: career,
                activeSemesters: configs[key] ?? {},
                selectableSemesters:
                    selectableSemestersByCareer[career.id] ?? const <int>{},
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
