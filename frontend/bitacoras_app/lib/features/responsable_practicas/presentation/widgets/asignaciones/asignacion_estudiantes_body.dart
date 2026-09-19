import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../controllers/asignacion_estudiante_controller.dart';
import '../../../domain/models/asignacion_estudiante_model.dart';
import 'asignacion_estudiante_card.dart';

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
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: controller.searchAssignments,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Buscar por estudiante o cédula...',
              hintStyle: const TextStyle(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
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
                        .where((parallel) => parallel['semestre_id'] == semester['id'])
                        .toList();
                    return ExpansionTile(
                      leading: const Icon(Icons.school_outlined, color: AppColors.primary),
                      title: Text('${semester['nombre']} (Nivel ${semester['nivel']})'),
                      children: semesterParallels.map((parallel) {
                        final students = assignmentsByParallel[parallel['id']] ?? [];
                        return ExpansionTile(
                          title: Text('Paralelo ${parallel['nombre']} - ${parallel['jornada']}'),
                          subtitle: Text('${students.length} estudiantes'),
                          children: students.isEmpty
                              ? [const ListTile(title: Text('No hay estudiantes en este paralelo.'))]
                              : students.map((assignment) => AsignacionEstudianteCard(
                                  assignment: assignment,
                                  controller: controller,
                                )).toList(),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}