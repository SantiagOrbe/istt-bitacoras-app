import 'package:bitacoras_app/features/tutores/tutores.dart';

class EncabezadoSeguimientoEstudiante extends StatelessWidget {
  final EstudianteAsignadoModel item;

  const EncabezadoSeguimientoEstudiante({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final student = item.student;

    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student.name, style: AppEstiloTexto.heading),
            AppTamanos.gapV4,
            Text(
              student.company ?? 'Empresa no registrada',
              style: AppEstiloTexto.body.copyWith(color: AppColores.textSecondary),
            ),
            AppTamanos.gapV12,
            Row(
              children: [
                Expanded(
                  child: _StatPill(
                    label: 'Horas',
                    value:
                        '${item.totalHoursCompletedLabel} / ${item.totalHoursRequiredLabel} h',
                  ),
                ),
                AppTamanos.gapH12,
                Expanded(
                  child: _StatPill(
                    label: 'Estado',
                    value: item.status,
                  ),
                ),
              ],
            ),
            AppTamanos.gapV12,
            LinearProgressIndicator(
              value: item.progressPercentage,
              minHeight: 9,
              backgroundColor: AppColores.divider,
              color: AppColores.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTamanos.md),
      decoration: BoxDecoration(
        color: AppColores.infoSoft,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppEstiloTexto.caption),
          AppTamanos.gapV4,
          Text(value, style: AppEstiloTexto.bodyBold),
        ],
      ),
    );
  }
}
