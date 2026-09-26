import 'package:bitacoras_app/features/admin/admin.dart';

class GestionPeriodoActions {
  final BuildContext context;
  final GestionPeriodoController controller;

  const GestionPeriodoActions({
    required this.context,
    required this.controller,
  });

  Future<void> openPeriodForm({PeriodoModel? period}) async {
    final result = await showModalBottomSheet<PeriodoFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HojaFormularioPeriodo(period: period),
    );

    if (result == null || !context.mounted) {
      return;
    }

    final success = await controller.savePeriod(
      periodId: period?.id,
      name: result.name,
      startDate: result.startDate,
      endDate: result.endDate,
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

  Future<void> toggleStatus(PeriodoModel period) async {
    if (period.isActive) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Desactivar período'),
          content: const Text(
            'Si desactivas este período, también quedarán bloqueadas las configuraciones de carreras y semestres asociadas a este periodo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: AppColores.error),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    final success = period.isActive
        ? await controller.deactivatePeriod(period)
        : await controller.activatePeriod(period);

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
}
