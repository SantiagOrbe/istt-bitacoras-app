import 'package:bitacoras_app/shared/exports.dart';

class ReportesHeader extends StatelessWidget {
  const ReportesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reportes',
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        AppSizes.gapV4,
        Text(
          'Tus reportes listos para descargar',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
