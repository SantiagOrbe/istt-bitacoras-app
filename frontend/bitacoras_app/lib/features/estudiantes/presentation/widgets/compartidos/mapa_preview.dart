import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:latlong2/latlong.dart';

class MapaPreview extends StatelessWidget {
  final String? mapImageUrl;
  final bool isGpsActive;
  final String statusLabel;
  final double? latitude;
  final double? longitude;
  final double radiusInMeters;

  const MapaPreview({
    super.key,
    this.mapImageUrl,
    this.isGpsActive = true,
    this.statusLabel = 'GPS Activo',
    this.latitude,
    this.longitude,
    this.radiusInMeters = 200,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocation = latitude != null && longitude != null;
    final centerLat = latitude ?? -0.9938;
    final centerLng = longitude ?? -77.8128;
    final activeColor = isGpsActive ? AppColors.primary : AppColors.error;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.outline),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: AppSizes.sm + 4,
              left: AppSizes.sm + 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.business_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    AppSizes.gapH4,
                    Text(
                      'Ubicación de la empresa',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: hasLocation
                  ? FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(centerLat, centerLng),
                        initialZoom: 15,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.bitacoras_app',
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: LatLng(centerLat, centerLng),
                              radius: radiusInMeters,
                              useRadiusInMeter: true,
                              color: AppColors.primary.withValues(alpha: 0.18),
                              borderColor: AppColors.primary,
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(centerLat, centerLng),
                              width: 32,
                              height: 32,
                              child: const Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      color: AppColors.background,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_off,
                              size: 34,
                              color: AppColors.textSecondary,
                            ),
                            AppSizes.gapV8,
                            Text(
                              'Ubicación no disponible',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
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
