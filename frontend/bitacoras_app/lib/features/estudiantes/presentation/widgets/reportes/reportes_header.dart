import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class ReportesHeader extends StatelessWidget {
  const ReportesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Row(
          children: [
            const Icon(Icons.assessment_outlined, color: AppColores.primary, size: 28),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reportes y bitácoras',
                    style: AppEstiloTexto.title.copyWith(
                      fontSize: 22,
                      color: AppColores.primary,
                    ),
                  ),
                  AppTamanos.gapV4,
                  Text(
                    'Consulta tu avance y genera el documento institucional.',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
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
