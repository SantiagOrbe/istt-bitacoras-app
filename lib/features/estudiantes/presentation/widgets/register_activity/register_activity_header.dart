import 'package:bitacoras_app/shared/exports.dart';

class RegisterActivityHeader extends StatelessWidget {
  const RegisterActivityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalles de la Actividad',
          style: AppTextStyles.title.copyWith(
            color: AppColors.primary,
            fontSize: 20,
          ),
        ),
        AppSizes.gapV4,
        Text(
          'Complete los campos para registrar una nueva actividad en su bitácora de prácticas.',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}