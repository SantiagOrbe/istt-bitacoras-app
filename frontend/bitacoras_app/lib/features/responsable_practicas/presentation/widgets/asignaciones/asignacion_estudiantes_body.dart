import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


class AsignacionEstudiantesBody extends StatelessWidget {
  final AsignacionEstudianteController controller;

  const AsignacionEstudiantesBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final assignmentsByParallel = <String, List<AsignacionEstudianteModel>>{};
    for (final assignment in controller.assignments) {
      assignmentsByParallel
          .putIfAbsent(assignment.parallelId ?? '', () => [])
          .add(assignment);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTamanos.md,
            AppTamanos.md,
            AppTamanos.md,
            AppTamanos.sm,
          ),
          child: InstitutionalGlowCard(
            accentColor: AppColores.primary,
            child: Padding(
              padding: const EdgeInsets.all(AppTamanos.md),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColores.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                    ),
                    child: const Icon(
                      Icons.assignment_ind_outlined,
                      color: AppColores.primary,
                    ),
                  ),
                  AppTamanos.gapH12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asignación de estudiantes',
                          style: AppEstiloTexto.title,
                        ),
                        AppTamanos.gapV4,
                        Text(
                          '${controller.assignments.length} estudiantes consultados',
                          style: AppEstiloTexto.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTamanos.md,
            AppTamanos.sm,
            AppTamanos.md,
            AppTamanos.md,
          ),
          child: TextField(
            onChanged: controller.searchAssignments,
            style: const TextStyle(color: AppColores.textPrimary),
            decoration: InputDecoration(
              hintText: 'Buscar por estudiante o cédula...',
              hintStyle: const TextStyle(color: AppColores.textHint),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColores.textSecondary,
              ),
              filled: true,
              fillColor: AppColores.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                borderSide: const BorderSide(color: AppColores.outline),
              ),
            ),
          ),
        ),
        Expanded(
          child: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColores.primary),
                )
              : controller.semesters.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay semestres habilitados para prácticas.',
                        style: TextStyle(color: AppColores.textSecondary),
                      ),
                    )
                  : ListView(
                      children: controller.semesters.map((semester) {
                        final semesterParallels = controller.parallels
                            .where(
                              (parallel) =>
                                  parallel['semestre_id'] == semester['id'],
                            )
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTamanos.md,
                            vertical: AppTamanos.sm,
                          ),
                          child: InstitutionalGlowCard(
                            accentColor: AppColores.primary,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.school_outlined,
                                  color: AppColores.primary,
                                ),
                                title: Text(
                                  '${semester['nombre']} (Nivel ${semester['nivel']})',
                                  style: AppEstiloTexto.bodyBold,
                                ),
                                children: semesterParallels.map((parallel) {
                                  final students =
                                      assignmentsByParallel[parallel['id']] ?? [];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppTamanos.sm,
                                    ),
                                    child: ExpansionTile(
                                      leading: const Icon(
                                        Icons.groups_outlined,
                                        color: AppColores.secondary,
                                      ),
                                      title: Text(
                                        'Paralelo ${parallel['nombre']}',
                                        style: AppEstiloTexto.bodyBold,
                                      ),
                                      subtitle: Text(
                                        '${students.length} estudiantes · ${parallel['jornada']}',
                                      ),
                                      children: students.isEmpty
                                          ? [
                                              const ListTile(
                                                title: Text(
                                                  'No hay estudiantes en este paralelo.',
                                                ),
                                              ),
                                            ]
                                          : students
                                              .map(
                                                (assignment) =>
                                                    AsignacionEstudianteCard(
                                                  assignment: assignment,
                                                  controller: controller,
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
        ),
      ],
    );
  }
}