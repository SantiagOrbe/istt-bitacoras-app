import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';


Future<void> mostrarDialogoErrorGps(
  BuildContext context, {
  required String distanceText,
  VoidCallback? onRetry,
  VoidCallback? onCancel,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
      ),
      backgroundColor: AppColores.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono de Ubicación Deshabilitada / Fuera de Rango
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColores.error.withValues(alpha: 0.12),
              child: const Icon(
                Icons.location_off_rounded,
                color: AppColores.error,
                size: 36,
              ),
            ),

            AppTamanos.gapV16,

            Text(
              '¡UPS! Ubicación no válida',
              textAlign: TextAlign.center,
              style: AppEstiloTexto.title.copyWith(
                color: AppColores.error,
                fontSize: 18,
              ),
            ),

            AppTamanos.gapV8,

            Text(
              'Su ubicación actual no está dentro del rango permitido para la empresa/institución asignada.',
              textAlign: TextAlign.center,
              style: AppEstiloTexto.caption.copyWith(
                color: AppColores.textSecondary,
                fontSize: 13,
              ),
            ),

            AppTamanos.gapV16,

            // Badge de Distancia Dinámica
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTamanos.md,
                vertical: AppTamanos.xs + 2,
              ),
              decoration: BoxDecoration(
                color: AppColores.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.social_distance_rounded,
                    size: 16,
                    color: AppColores.error,
                  ),
                  AppTamanos.gapH8,
                  Text(
                    'Distancia: $distanceText',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            AppTamanos.gapV24,

            // Botón Intentar de Nuevo
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColores.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onRetry != null) onRetry();
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColores.surface,
                  size: 18,
                ),
                label: Text(
                  'Intentar de Nuevo',
                  style: AppEstiloTexto.bodyBold.copyWith(
                    color: AppColores.surface,
                  ),
                ),
              ),
            ),

            AppTamanos.gapV8,

            // Botón Cancelar
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
                  ),
                  side: const BorderSide(color: AppColores.primary),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
                child: Text(
                  'Cancelar',
                  style: AppEstiloTexto.bodyBold.copyWith(
                    color: AppColores.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
