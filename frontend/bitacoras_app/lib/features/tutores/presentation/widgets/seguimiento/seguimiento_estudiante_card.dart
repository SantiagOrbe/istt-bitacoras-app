import 'package:bitacoras_app/features/tutores/tutores.dart';


class SeguimientoEstudianteCard extends StatelessWidget {
  final EstudianteAsignadoModel item;
  final VoidCallback onTap;

  const SeguimientoEstudianteCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final student = item.student;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTamanos.sm),
      child: InstitutionalGlowCard(
        accentColor: AppColores.secondary,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(student.name, style: AppEstiloTexto.bodyBold, overflow: TextOverflow.ellipsis)),
                  Text('${(item.progressPercentage * 100).toInt()}%', style: AppEstiloTexto.bodyBold.copyWith(color: AppColores.primary)),
                ],
              ),
              AppTamanos.gapV4,
              Text('Completadas: ${item.totalHoursCompletedLabel} hrs | Restantes: ${item.remainingHoursLabel} hrs', style: AppEstiloTexto.caption),
              AppTamanos.gapV8,
              LinearProgressIndicator(value: item.progressPercentage, backgroundColor: AppColores.divider, color: AppColores.primary, minHeight: 6),
              AppTamanos.gapV12,
              const Divider(height: 1),
              AppTamanos.gapV12,
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColores.textSecondary),
                  const SizedBox(width: 4),
                  Text('Última asistencia: ${item.lastAttendanceTime ?? "Sin registro"}', style: AppEstiloTexto.caption),
                ],
              ),
              AppTamanos.gapV4,
              Row(
                children: [
                  const Icon(Icons.event_note, size: 14, color: AppColores.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Última actividad: ${item.lastActivityDescription ?? "Sin actividad"}',
                      style: AppEstiloTexto.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}