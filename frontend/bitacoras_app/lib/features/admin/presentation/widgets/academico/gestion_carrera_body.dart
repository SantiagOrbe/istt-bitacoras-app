import 'package:bitacoras_app/features/admin/admin.dart';

class GestionCarreraBody extends StatelessWidget {
  final List<CarreraModel> careers;
  final int totalCareers;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<CarreraModel> onCareerTap;

  const GestionCarreraBody({
    super.key,
    required this.careers,
    required this.totalCareers,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onCareerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTamanos.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTamanos.gapV12,
          Text(
            'Gestión de Carreras',
            style: AppEstiloTexto.heading.copyWith(
              color: AppColores.textPrimary,
            ),
          ),
          AppTamanos.gapV12,
          CarreraSearchBar(onChanged: onSearchChanged),
          AppTamanos.gapV12,
          Text(
            '$totalCareers carreras registradas',
            style: AppEstiloTexto.caption.copyWith(
              color: AppColores.textSecondary,
            ),
          ),
          AppTamanos.gapV12,
          Expanded(
            child: careers.isEmpty
                ? CarreraEmptyState(hasSearchQuery: searchQuery.isNotEmpty)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: careers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppTamanos.sm),
                    itemBuilder: (context, index) {
                      final career = careers[index];
                      return CarreraCard(
                        career: career,
                        onTap: () => onCareerTap(career),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
