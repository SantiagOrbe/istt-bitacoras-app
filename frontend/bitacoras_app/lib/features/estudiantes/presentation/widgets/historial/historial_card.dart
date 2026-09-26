import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';


class HistorialCard extends StatelessWidget {
  final RegistroAsistenciaModel record;
  final VoidCallback onDetailPressed;

  const HistorialCard({
    super.key,
    required this.record,
    required this.onDetailPressed,
  });

  // Helper para asignar color según el estado del registro
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completado':
      case 'aprobado':
        return AppColores.success;
      case 'pendiente':
      case 'en proceso':
        return AppColores.warning;
      case 'rechazado':
      case 'incompleto':
        return AppColores.error;
      default:
        return AppColores.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(record.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTamanos.md),
      padding: const EdgeInsets.all(AppTamanos.md),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        border: Border.all(color: AppColores.outline),
      ),
      child: Column(
        children: [
          // Header: Fecha y Badge de Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColores.textPrimary,
                    size: 18,
                  ),
                  AppTamanos.gapH8,
                  Text(
                    record.date,
                    style: AppEstiloTexto.bodyBold.copyWith(
                      fontSize: 16,
                      color: AppColores.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTamanos.sm + 2,
                  vertical: AppTamanos.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: statusColor,
                    ),
                    AppTamanos.gapH4,
                    Text(
                      record.status,
                      style: AppEstiloTexto.caption.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(height: 24, color: AppColores.divider),

          // Fila de Horarios: Entrada y Salida
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entrada',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    AppTamanos.gapV4,
                    Text(
                      record.entryTimeLabel,
                      style: AppEstiloTexto.bodyBold.copyWith(
                        fontSize: 15,
                        color: AppColores.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salida',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    AppTamanos.gapV4,
                    Text(
                      record.exitTime != null ? record.exitTimeLabel : '--:--',
                      style: AppEstiloTexto.bodyBold.copyWith(
                        fontSize: 15,
                        color: AppColores.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppTamanos.gapV16,

          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
                ),
                side: const BorderSide(color: AppColores.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTamanos.md,
                  vertical: AppTamanos.xs,
                ),
              ),
              onPressed: onDetailPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver actividades',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppTamanos.gapH4,
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColores.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
