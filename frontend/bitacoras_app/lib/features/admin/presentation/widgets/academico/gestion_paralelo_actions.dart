import 'package:bitacoras_app/features/admin/admin.dart';

class GestionParaleloActions {
  final BuildContext context;
  final GestionParaleloController controller;
  final IAdminRepository repository;
  final String? semesterId;

  const GestionParaleloActions({
    required this.context,
    required this.controller,
    required this.repository,
    this.semesterId,
  });

  Future<void> openParallelForm({ParaleloModel? parallel}) async {
    if (controller.cycles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero crea al menos un semestre.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await showModalBottomSheet<ParaleloFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HojaFormularioParalelo(
        cycles: controller.cycles,
        parallel: parallel,
        fixedCycleId: semesterId,
      ),
    );

    if (result == null || !context.mounted) {
      return;
    }

    final success = await controller.saveParallel(
      parallelId: parallel?.id,
      cycleId: result.cycleId,
      name: result.name,
      jornada: result.jornada,
      isActive: result.isActive,
    );

    if (!context.mounted) {
      return;
    }

    final message = controller.successMessage ?? controller.errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColores.success : AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> toggleStatus(ParaleloModel parallel) async {
    final success = await controller.toggleStatus(parallel);

    if (!context.mounted) {
      return;
    }

    final message = controller.successMessage ?? controller.errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColores.success : AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> assignStudents(ParaleloModel parallel) async {
    try {
      final students = await repository.obtenerEstudiantesParalelo(parallel.id);
      final selected = students
          .where((student) => student['seleccionado'] == true)
          .map((student) => int.tryParse(student['id']?.toString() ?? ''))
          .whereType<int>()
          .toSet();

      if (!context.mounted) return;

      final result = await showDialog<Set<int>>(
        context: context,
        builder: (context) => AsignacionEstudiantesDialog(
          estudiantes: students,
          seleccionados: selected,
          nombreParalelo: parallel.name,
        ),
      );

      if (result == null || !context.mounted) return;

      await repository.asignarEstudiantesParalelo(parallel.id, result.toList());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiantes asignados correctamente.')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> removeAllStudents(ParaleloModel parallel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirar estudiantes'),
        content: Text(
          '¿Quieres retirar todos los estudiantes del paralelo ${parallel.name}? '
          'Luego podrás asignarlos a otro semestre.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Retirar todos'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await repository.eliminarEstudiantesParalelo(parallel.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estudiantes retirados correctamente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
