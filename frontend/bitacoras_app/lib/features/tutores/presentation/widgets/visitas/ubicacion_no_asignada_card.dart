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
      accentColor: AppColores.error,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTamanos.md),
        color: AppColores.errorSoft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_off_outlined, color: AppColores.error),
          AppTamanos.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppEstiloTexto.bodyBold,
                ),
                AppTamanos.gapV4,
                Text(
                  message,
                  style: AppEstiloTexto.caption,
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
