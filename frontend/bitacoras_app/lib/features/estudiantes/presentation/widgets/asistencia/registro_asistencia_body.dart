import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';


class RegistroAsistenciaBody extends StatelessWidget {
  final String title;
  final String currentTime;
  final String currentDate;
  final String companyName;
  final bool isGpsValid;
  final bool locationAvailable;
  final double? latitude;
  final double? longitude;
  final double? allowedRadiusMeters;
  final String? validationMessage;

  const RegistroAsistenciaBody({
    super.key,
    required this.title,
    required this.currentTime,
    required this.currentDate,
    required this.companyName,
    this.isGpsValid = true,
    this.locationAvailable = true,
    this.latitude,
    this.longitude,
    this.allowedRadiusMeters,
    this.validationMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isEntry = title.toLowerCase().contains('entrada');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InstitutionalGlowCard(
          accentColor: isEntry ? AppColors.primary : AppColors.secondary,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (isEntry ? AppColors.primary : AppColors.secondary)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(
                    isEntry ? Icons.login_rounded : Icons.logout_rounded,
                    color: isEntry ? AppColors.primary : AppColors.secondary,
                    size: 26,
                  ),
                ),
                AppSizes.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 23,
                          color: AppColors.primary,
                        ),
                      ),
                      AppSizes.gapV4,
                      Text(
                        isEntry
                            ? 'Valida tu ubicación para iniciar la jornada.'
                            : 'Valida tu ubicación para cerrar la jornada.',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSizes.gapV16,

        // 1. AsistenciaInfoTile pasando 'time' y 'date'
        AsistenciaInfoTile(time: currentTime, date: currentDate),

        AppSizes.gapV16,
        MapaPreview(
          latitude: latitude,
          longitude: longitude,
          radiusInMeters: allowedRadiusMeters ?? 200,
          isGpsActive: isGpsValid,
          statusLabel: isGpsValid ? 'GPS Activo' : 'GPS Fuera de rango',
        ),
        AppSizes.gapV16,

        // 2. UbicacionEstadoCard pasando 'isValid'
        if (locationAvailable) UbicacionEstadoCard(isValid: isGpsValid),

        if (validationMessage != null) ...[
          AppSizes.gapV8,
          Text(
            validationMessage!,
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ],

        AppSizes.gapV16,
        EmpresaCard(companyName: companyName),
      ],
    );
  }
}
