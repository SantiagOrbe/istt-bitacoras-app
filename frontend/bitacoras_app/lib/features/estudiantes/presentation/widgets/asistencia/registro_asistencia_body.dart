// lib/features/estudiantes/presentation/widgets/asistencia/registro_asistencia_body.dart
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            color: AppColors.primary,
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
