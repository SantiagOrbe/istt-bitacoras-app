import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';


class UbicacionEstadoCard extends StatelessWidget {
  final bool isValid;
  final String? message;

  const UbicacionEstadoCard({super.key, required this.isValid, this.message});

  @override
  Widget build(BuildContext context) {
    final statusColor = isValid ? AppColors.success : AppColors.error;
    final statusText =
        message ??
        (isValid ? 'Dentro del rango permitido' : 'Fuera del rango permitido');

    return InstitutionalGlowCard(
      accentColor: statusColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isValid ? Icons.location_on : Icons.location_off,
              color: statusColor,
              size: 20,
            ),
          ),
          AppSizes.gapH12,
          Expanded(
            child: Text(
              statusText,
              style: AppTextStyles.bodyBold.copyWith(color: statusColor),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
