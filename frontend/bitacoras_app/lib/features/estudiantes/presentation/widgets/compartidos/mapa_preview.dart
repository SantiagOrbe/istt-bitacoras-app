import 'package:bitacoras_app/shared/exports.dart';

class MapaPreview extends StatelessWidget {
  final String? mapImageUrl;
  final bool isGpsActive;
  final String statusLabel;

  const MapaPreview({
    super.key,
    this.mapImageUrl,
    this.isGpsActive = true,
    this.statusLabel = 'GPS Activo',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveImageUrl =
        mapImageUrl ?? 'https://tile.openstreetmap.org/15/9385/16834.png';
    final activeColor = isGpsActive ? AppColors.primary : AppColors.error;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.outline.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.outline),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Imagen del mapa de fondo con manejo de carga y error
            Positioned.fill(
              child: Image.network(
                effectiveImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surface,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.map_outlined,
                          size: 32,
                          color: AppColors.textSecondary,
                        ),
                        AppSizes.gapV4,
                        Text(
                          'No se pudo cargar el mapa',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Marcador central (Pin de ubicación)
            Center(
              child: Icon(
                Icons.location_on_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ),

            // Badge inferior indicando el estado del GPS
            Positioned(
              bottom: AppSizes.sm + 4,
              right: AppSizes.sm + 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm + 2,
                  vertical: AppSizes.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGpsActive
                          ? Icons.gps_fixed_rounded
                          : Icons.gps_off_rounded,
                      size: 14,
                      color: activeColor,
                    ),
                    AppSizes.gapH4,
                    Text(
                      statusLabel,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
