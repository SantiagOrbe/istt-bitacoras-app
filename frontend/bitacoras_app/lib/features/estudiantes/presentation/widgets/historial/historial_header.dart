import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class HistorialHeader extends StatelessWidget {
  final String semesterName;
  final int percentage;
  final double completedHours;
  final double totalHours;

  const HistorialHeader({
    super.key,
    this.semesterName = 'Semestre actual',
    this.percentage = 0,
    this.completedHours = 0,
    this.totalHours = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: percentage >= 100 ? AppColores.success : AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTamanos.sm + 2),
                decoration: BoxDecoration(
                  color: AppColores.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                ),
                child: const Icon(
                  Icons.timeline_rounded,
                  color: AppColores.primary,
                  size: 24,
                ),
              ),
              AppTamanos.gapH16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avance de prácticas',
                      style: AppEstiloTexto.title.copyWith(
                        fontSize: 22,
                        color: AppColores.primary,
                      ),
                    ),
                    Text(
                      semesterName,
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppTamanos.gapV16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentage% completado',
                style: AppEstiloTexto.bodyBold.copyWith(
                  fontSize: 16,
                  color: AppColores.textPrimary,
                ),
              ),
              Text(
                '${completedHours.toStringAsFixed(1)}h / ${totalHours.toStringAsFixed(0)}h',
                style: AppEstiloTexto.caption.copyWith(
                  color: AppColores.textSecondary,
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
