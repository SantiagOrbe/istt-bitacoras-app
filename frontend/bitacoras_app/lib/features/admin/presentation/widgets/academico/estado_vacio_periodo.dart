import 'package:bitacoras_app/features/admin/admin.dart';

class PeriodoEmptyState extends StatelessWidget {
  final bool hasSearchQuery;

  const PeriodoEmptyState({super.key, required this.hasSearchQuery});

  @override
  Widget build(BuildContext context) {
    final title = hasSearchQuery
        ? 'No se encontraron períodos'
        : 'Aún no hay períodos lectivos';
    final subtitle = hasSearchQuery
        ? 'Prueba con otro criterio de búsqueda.'
        : 'Crea el primer período lectivo para comenzar.';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTamanos.lg),
            decoration: BoxDecoration(
              color: AppColores.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              size: 40,
              color: AppColores.secondary,
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
