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
      padding: const EdgeInsets.symmetric(horizontal: AppTamanos.md, vertical: AppTamanos.xs),
      child: InstitutionalGlowCard(
        accentColor: isAssigned ? AppColores.success : AppColores.warning,
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
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
                    style: AppEstiloTexto.bodyBold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAssigned ? AppColores.successSoft : AppColores.warningSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAssigned ? 'Asignado' : 'Pendiente',
                    style: TextStyle(
                      fontSize: 11,
                      color: isAssigned ? AppColores.success : AppColores.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Cédula: ${assignment.studentIdentification.isEmpty ? 'No registrada' : assignment.studentIdentification}',
              style: AppEstiloTexto.caption,
            ),
            if (isAssigned) ...[
              const Divider(color: AppColores.divider),
              Text('Empresa: ${assignment.companyName}', style: AppEstiloTexto.body),
              Text('Tutor Académico: ${assignment.academicTutorName}', style: AppEstiloTexto.body),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(
                    AppRoutes.formularioAsignacionResponsable,
                    extra: {'assignment': assignment, 'controller': controller},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColores.primary,
                  foregroundColor: AppColores.surface,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                  ),
                ),
                icon: Icon(isAssigned ? Icons.edit_rounded : Icons.add_link_rounded, color: AppColores.surface, size: 18),
                label: Text(
                  isAssigned ? 'Reasignar Tutores' : 'Asignar Tutores',
                  style: const TextStyle(color: AppColores.surface),
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