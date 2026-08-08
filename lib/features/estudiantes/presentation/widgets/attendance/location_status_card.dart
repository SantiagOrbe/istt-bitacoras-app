
import 'package:bitacoras_app/shared/exports.dart';

class LocationStatusCard extends StatelessWidget {
  final bool isValid;
  final String? message;

  const LocationStatusCard({
    super.key,
    required this.isValid,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isValid ? AppColors.success : AppColors.error;
    final statusText = message ?? (isValid ? 'Dentro del rango permitido' : 'Fuera del rango permitido');

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          Icon(isValid ? Icons.location_on : Icons.location_off, color: statusColor),
          AppSizes.gapH12,
          Expanded(
            child: Text(
              statusText,
              style: AppTextStyles.bodyBold.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}