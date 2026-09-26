import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class SesionActivaCard extends StatelessWidget {
  final RegistroAsistenciaModel record;
  final VoidCallback onExitPressed;

  const SesionActivaCard({
    super.key,
    required this.record,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos el amarillo institucional (warning) para dar contexto de "En Proceso"
    final warningAccent = AppColores.warning;

    return Container(
      padding: const EdgeInsets.all(AppTamanos.md),
      decoration: BoxDecoration(
        color: warningAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        border: Border.all(
          color: warningAccent.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Cabecera: Fecha y Estado de la sesión
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
                  Text(record.date, style: AppEstiloTexto.bodyBold),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTamanos.sm,
                  vertical: AppTamanos.xs,
                ),
                decoration: BoxDecoration(
                  color: warningAccent.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 14,
                      color: AppColores.textPrimary,
                    ),
                    AppTamanos.gapH4,
                    Text(
                      record.status,
                      style: AppEstiloTexto.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColores.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppTamanos.sm),
            child: Divider(color: AppColores.divider),
          ),

          // Horarios de Entrada y Salida
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entrada',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                  AppTamanos.gapV4,
                  Text(record.entryTimeLabel, style: AppEstiloTexto.bodyBold),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Salida',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                  AppTamanos.gapV4,
                  Text(
                    record.exitTime != null ? record.exitTimeLabel : 'Esperando marcación...',
                    style: AppEstiloTexto.caption.copyWith(
                      fontStyle: record.exitTime == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                      color: record.exitTime == null
                          ? AppEstiloTexto.caption.color
                          : AppColores.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          AppTamanos.gapV16,

          // Botón de Marcación de Salida
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              text: 'Marcar Salida',
              icon: Icons.location_on_outlined,
              isFullWidth: false,
              onPressed: onExitPressed,
            ),
          ),
        ],
      ),
    );
  }
}
