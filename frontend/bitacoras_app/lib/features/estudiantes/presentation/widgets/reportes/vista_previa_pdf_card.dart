import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class VistaPreviaPdfCard extends StatelessWidget {
  const VistaPreviaPdfCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(AppTamanos.md),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        border: Border.all(color: AppColores.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.find_in_page_outlined,
            size: 40,
            color: AppColores.primary,
          ),
          AppTamanos.gapV8,
          Text(
            'BITÁCORA DEL ESTUDIANTE',
            style: AppEstiloTexto.bodyBold.copyWith(
              fontSize: 12,
              color: AppColores.primary,
            ),
          ),
          AppTamanos.gapV4,
          Text(
            'FORMACIÓN PRÁCTICA EN EL ENTORNO LABORAL REAL',
            textAlign: TextAlign.center,
            style: AppEstiloTexto.caption.copyWith(
              fontSize: 10,
              color: AppColores.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
