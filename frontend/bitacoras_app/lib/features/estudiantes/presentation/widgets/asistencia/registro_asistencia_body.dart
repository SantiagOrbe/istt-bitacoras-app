// lib/features/estudiantes/presentation/widgets/asistencia/registro_asistencia_body.dart
import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class RegistroAsistenciaBody extends StatelessWidget {
  final String title;
  final String currentTime;
  final String currentDate;
  final String companyName;
  final bool isGpsValid;

  const RegistroAsistenciaBody({
    super.key,
    required this.title,
    required this.currentTime,
    required this.currentDate,
    required this.companyName,
    this.isGpsValid = true,
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
        const MapaPreview(),
        AppSizes.gapV16,

        // 2. UbicacionEstadoCard pasando 'isValid'
        UbicacionEstadoCard(isValid: isGpsValid),

        AppSizes.gapV16,
        EmpresaCard(companyName: companyName),
      ],
    );
  }
}
