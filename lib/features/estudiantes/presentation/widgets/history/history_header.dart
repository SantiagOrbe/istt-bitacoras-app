import 'package:bitacoras_app/shared/exports.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm + 2),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: const Icon(
            Icons.history_rounded,
            color: AppColors.warning,
            size: 24,
          ),
        ),
        AppSizes.gapH16,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historial',
              style: AppTextStyles.title.copyWith(
                fontSize: 22,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Tus registros de asistencia recientes',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}