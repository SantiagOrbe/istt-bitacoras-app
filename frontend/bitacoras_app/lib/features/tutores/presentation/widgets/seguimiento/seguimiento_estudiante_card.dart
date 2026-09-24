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
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: InstitutionalGlowCard(
        accentColor: AppColors.secondary,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(student.name, style: AppTextStyles.bodyBold, overflow: TextOverflow.ellipsis)),
                  Text('${(item.progressPercentage * 100).toInt()}%', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary)),
                ],
              ),
              AppSizes.gapV4,
              Text('Completadas: ${item.totalHoursCompletedLabel} hrs | Restantes: ${item.remainingHoursLabel} hrs', style: AppTextStyles.caption),
              AppSizes.gapV8,
              LinearProgressIndicator(value: item.progressPercentage, backgroundColor: AppColors.divider, color: AppColors.primary, minHeight: 6),
              AppSizes.gapV12,
              const Divider(height: 1),
              AppSizes.gapV12,
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('Última asistencia: ${item.lastAttendanceTime ?? "Sin registro"}', style: AppTextStyles.caption),
                ],
              ),
              AppSizes.gapV4,
              Row(
                children: [
                  const Icon(Icons.event_note, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Última actividad: ${item.lastActivityDescription ?? "Sin actividad"}',
                      style: AppTextStyles.caption,
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