import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraEmptyState extends StatelessWidget {
  final bool hasSearchQuery;

  const CarreraEmptyState({super.key, required this.hasSearchQuery});

  @override
  Widget build(BuildContext context) {
    final title = hasSearchQuery
        ? 'No se encontraron carreras'
        : 'Aún no hay carreras registradas';
    final subtitle = hasSearchQuery
        ? 'Intenta con otro criterio de búsqueda.'
        : 'Agrega la primera carrera para comenzar con la gestión.';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTamanos.lg),
            decoration: BoxDecoration(
              color: AppColores.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_tree_rounded,
              size: 40,
              color: AppColores.primary,
            ),
          ),
          AppTamanos.gapV16,
          Text(
            title,
            style: AppEstiloTexto.bodyBold.copyWith(
              color: AppColores.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppTamanos.gapV8,
          Text(
            subtitle,
            style: AppEstiloTexto.caption.copyWith(
              color: AppColores.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
