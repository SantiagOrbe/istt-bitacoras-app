import 'package:bitacoras_app/features/admin/admin.dart';

class GestionParaleloBody extends StatelessWidget {
  final bool isLoading;
  final String searchQuery;
  final String statusFilter;
  final List<CicloModel> cycles;
  final List<ParaleloModel> parallels;
  final String subtitle;
  final int count;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final Future<void> Function({ParaleloModel? parallel}) onParallelTap;
  final ValueChanged<ParaleloModel> onToggleStatus;
  final ValueChanged<ParaleloModel> onAssignStudents;
  final ValueChanged<ParaleloModel> onRemoveStudents;

  const GestionParaleloBody({
    super.key,
    required this.isLoading,
    required this.searchQuery,
    required this.statusFilter,
    required this.cycles,
    required this.parallels,
    required this.subtitle,
    required this.count,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onParallelTap,
    required this.onToggleStatus,
    required this.onAssignStudents,
    required this.onRemoveStudents,
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
            icon: Icons.groups_rounded,
            title: 'Gestión de paralelos',
            subtitle: subtitle,
            count: '$count',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarreraSearchBar(
                  onChanged: onSearchChanged,
                  hintText: 'Buscar paralelo o jornada...',
                ),
                AppTamanos.gapV12,
                SingleChildScrollView(
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
              ],
            ),
          ),
          AppTamanos.gapV16,
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColores.primary),
                  )
                : parallels.isEmpty
                ? EstadoVacioAdmin(
                    title: searchQuery.isNotEmpty
                        ? 'No se encontraron paralelos'
                        : 'Aún no hay paralelos registrados',
                    subtitle: searchQuery.isNotEmpty
                        ? 'Prueba con otro criterio de búsqueda.'
                        : 'Crea el primer paralelo para comenzar.',
                    icon: Icons.groups_rounded,
                    accentColor: AppColores.primary,
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: parallels.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppTamanos.sm),
                    itemBuilder: (context, index) {
                      final parallel = parallels[index];
                      return ParaleloCard(
                        parallel: parallel,
                        cycleName: _cycleNameFor(parallel.cycleId),
                        onTap: () => onParallelTap(parallel: parallel),
                        onToggleStatus: () => onToggleStatus(parallel),
                        onAssignStudents: () => onAssignStudents(parallel),
                        onRemoveStudents: () => onRemoveStudents(parallel),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _cycleNameFor(String cycleId) {
    final cycle = cycles.where((item) => item.id == cycleId).firstOrNull;
    return cycle?.name ?? 'Semestre';
  }
}
