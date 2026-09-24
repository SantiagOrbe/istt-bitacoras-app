import 'package:bitacoras_app/features/tutores/tutores.dart';


class UbicacionNoAsignadaCard extends StatelessWidget {
  final String title;
  final String message;

  const UbicacionNoAsignadaCard({
    super.key,
    this.title = 'Ubicación no asignada',
    this.message = 'Este tutor académico no tiene una empresa con ubicación GPS configurada. El responsable de prácticas debe completar la asignación antes de registrar la entrada.',
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColors.error,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.md),
        color: AppColors.errorSoft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_off_outlined, color: AppColors.error),
          AppSizes.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyBold,
                ),
                AppSizes.gapV4,
                Text(
                  message,
                  style: AppTextStyles.caption,
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
