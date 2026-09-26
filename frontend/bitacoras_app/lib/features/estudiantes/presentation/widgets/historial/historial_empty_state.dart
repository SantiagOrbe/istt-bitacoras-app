import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class HistorialEmptyState extends StatelessWidget {
  const HistorialEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTamanos.lg),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
        border: Border.all(color: AppColores.outline),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.assignment_late_outlined,
            size: 40,
            color: AppColores.textSecondary,
          ),
          AppTamanos.gapV8,
          Text(
            'No hay registros anteriores',
            style: AppEstiloTexto.bodyBold.copyWith(
              color: AppColores.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
