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
            AppSizes.md,
            AppSizes.md,
            AppSizes.md,
            AppSizes.sm,
          ),
          child: InstitutionalGlowCard(
            accentColor: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: const Icon(
                      Icons.assignment_ind_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  AppSizes.gapH12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asignación de estudiantes',
                          style: AppTextStyles.title,
                        ),
                        AppSizes.gapV4,
                        Text(
                          '${controller.assignments.length} estudiantes consultados',
                          style: AppTextStyles.caption,
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
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            AppSizes.md,
          ),
          child: TextField(
            onChanged: controller.searchAssignments,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Buscar por estudiante o cédula...',
              hintStyle: const TextStyle(color: AppColors.textHint),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
            ),
          ),
        ),
        Expanded(
          child: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : controller.semesters.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay semestres habilitados para prácticas.',
                        style: TextStyle(color: AppColors.textSecondary),
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
                            horizontal: AppSizes.md,
                            vertical: AppSizes.sm,
                          ),
                          child: InstitutionalGlowCard(
                            accentColor: AppColors.primary,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.school_outlined,
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  '${semester['nombre']} (Nivel ${semester['nivel']})',
                                  style: AppTextStyles.bodyBold,
                                ),
                                children: semesterParallels.map((parallel) {
                                  final students =
                                      assignmentsByParallel[parallel['id']] ?? [];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSizes.sm,
                                    ),
                                    child: ExpansionTile(
                                      leading: const Icon(
                                        Icons.groups_outlined,
                                        color: AppColors.secondary,
                                      ),
                                      title: Text(
                                        'Paralelo ${parallel['nombre']}',
                                        style: AppTextStyles.bodyBold,
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