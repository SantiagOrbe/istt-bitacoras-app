import 'package:bitacoras_app/features/admin/admin.dart';

class GestionPeriodoBody extends StatelessWidget {
  final bool isLoading;
  final String searchQuery;
  final List<PeriodoModel> periods;
  final Widget? accionPeriodoActivo;
  final ValueChanged<String> onSearchChanged;
  final Future<void> Function({PeriodoModel? period}) onOpenPeriodForm;
  final Future<void> Function(PeriodoModel) onToggleStatus;

  const GestionPeriodoBody({
    super.key,
    required this.isLoading,
    required this.searchQuery,
    required this.periods,
    this.accionPeriodoActivo,
    required this.onSearchChanged,
    required this.onOpenPeriodForm,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTamanos.md,
        AppTamanos.sm,
        AppTamanos.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AcademicoScreenHeader(
            icon: Icons.calendar_month_rounded,
            title: 'Períodos lectivos',
            subtitle: 'Vigencia académica y prácticas institucionales',
            count: '${periods.length}',
            child: CarreraSearchBar(
              onChanged: onSearchChanged,
              hintText: 'Buscar período lectivo...',
            ),
          ),
          if (accionPeriodoActivo != null) ...[
            AppTamanos.gapV12,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTamanos.md),
              child: accionPeriodoActivo!,
            ),
          ],
          AppTamanos.gapV16,
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColores.primary),
                  )
                : periods.isEmpty
                ? PeriodoEmptyState(hasSearchQuery: searchQuery.isNotEmpty)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: periods.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppTamanos.sm),
                    itemBuilder: (context, index) {
                      final period = periods[index];
                      return PeriodoCard(
                        period: period,
                        onTap: () => onOpenPeriodForm(period: period),
                        onToggleStatus: () => onToggleStatus(period),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
