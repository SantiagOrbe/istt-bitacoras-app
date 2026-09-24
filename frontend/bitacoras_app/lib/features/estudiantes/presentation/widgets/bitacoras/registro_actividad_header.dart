import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class RegistroActividadHeader extends StatelessWidget {
  const RegistroActividadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            const Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 28),
            AppSizes.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalles de la actividad',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                      fontSize: 20,
                    ),
                  ),
                  AppSizes.gapV4,
                  Text(
                    'Registra las tareas realizadas en tu bitácora de prácticas.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
