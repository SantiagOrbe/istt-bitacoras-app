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
        Container(
          margin: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            0,
          ),
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.outline),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
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
                    colors: [AppColors.secondary, AppColors.warning],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(Icons.tune_rounded, color: AppColors.surface),
              ),
              AppSizes.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Carreras y períodos', style: AppTextStyles.title),
                    Text(
                      'Habilita semestres para prácticas preprofesionales.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
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
