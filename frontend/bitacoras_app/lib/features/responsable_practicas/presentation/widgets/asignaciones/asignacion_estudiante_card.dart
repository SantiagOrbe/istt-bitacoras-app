import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

class AsignacionEstudianteCard extends StatelessWidget {
  final AsignacionEstudianteModel assignment;
  final AsignacionEstudianteController controller;

  const AsignacionEstudianteCard({
    super.key,
    required this.assignment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isAssigned = assignment.isAssigned;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
      child: InstitutionalGlowCard(
        accentColor: isAssigned ? AppColors.success : AppColors.warning,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    assignment.studentName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAssigned ? AppColors.successSoft : AppColors.warningSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAssigned ? 'Asignado' : 'Pendiente',
                    style: TextStyle(
                      fontSize: 11,
                      color: isAssigned ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Cédula: ${assignment.studentIdentification.isEmpty ? 'No registrada' : assignment.studentIdentification}',
              style: AppTextStyles.caption,
            ),
            if (isAssigned) ...[
              const Divider(color: AppColors.divider),
              Text('Empresa: ${assignment.companyName}', style: AppTextStyles.body),
              Text('Tutor Académico: ${assignment.academicTutorName}', style: AppTextStyles.body),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(
                    AppRoutes.responsablePracticasAssignStudentForm,
                    extra: {'assignment': assignment, 'controller': controller},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                icon: Icon(isAssigned ? Icons.edit_rounded : Icons.add_link_rounded, color: AppColors.surface, size: 18),
                label: Text(
                  isAssigned ? 'Reasignar Tutores' : 'Asignar Tutores',
                  style: const TextStyle(color: AppColors.surface),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}