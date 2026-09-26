import 'package:bitacoras_app/features/admin/admin.dart';

class GestionCicloBody extends StatelessWidget {
  final bool isLoading;
  final String careerName;
  final String searchQuery;
  final String statusFilter;
  final bool isAscendingOrder;
  final List<CicloModel> cycles;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onSortOrderChanged;
  final ValueChanged<CicloModel> onCycleTap;
  final Future<void> Function({CicloModel? cycle}) onEdit;
  final ValueChanged<CicloModel> onToggleStatus;

  const GestionCicloBody({
    super.key,
    required this.isLoading,
    required this.careerName,
    required this.searchQuery,
    required this.statusFilter,
    required this.isAscendingOrder,
    required this.cycles,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onSortOrderChanged,
    required this.onCycleTap,
    required this.onEdit,
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
            icon: Icons.school_rounded,
            title: 'Semestres de la carrera',
            subtitle: careerName,
            count: '${cycles.length}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarreraSearchBar(
                  onChanged: onSearchChanged,
                  hintText: 'Buscar semestre o nivel...',
                ),
                AppTamanos.gapV12,
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            AcademicoFilterChip(
                              label: 'Todos',
                              selected: statusFilter == 'all',
                              onSelected: (_) => onStatusChanged('all'),
                            ),
                            AcademicoFilterChip(
                              label: 'Activos',
                              selected: statusFilter == 'active',
                              onSelected: (_) => onStatusChanged('active'),
                            ),
                            AcademicoFilterChip(
                              label: 'Inactivos',
                              selected: statusFilter == 'inactive',
                              onSelected: (_) => onStatusChanged('inactive'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onSortOrderChanged,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        isAscendingOrder
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 18,
                      ),
                      label: Text(
                        isAscendingOrder ? '1 → 4' : '4 → 1',
                        style: AppEstiloTexto.caption,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppTamanos.gapV16,
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColores.primary),
                  )
                : cycles.isEmpty
                ? EstadoVacioAdmin(
                    title: searchQuery.isNotEmpty
                        ? 'No se encontraron semestres'
                        : 'Aún no hay semestres registrados',
                    subtitle: searchQuery.isNotEmpty
                        ? 'Prueba con otro criterio de búsqueda.'
                        : 'Crea el primer semestre para comenzar.',
                    icon: Icons.school_rounded,
                    accentColor: AppColores.primary,
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cycles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppTamanos.sm),
                    itemBuilder: (context, index) {
                      final cycle = cycles[index];
                      return CicloCard(
                        cycle: cycle,
                        onTap: () => onCycleTap(cycle),
                        onEdit: () => onEdit(cycle: cycle),
                        onToggleStatus: () => onToggleStatus(cycle),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
