import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../../domain/models/registro_asistencia_model.dart';
import 'historial_empty_state.dart';
import 'historial_header.dart';

class HistorialBody extends StatelessWidget {
  final RegistroAsistenciaModel? activeRecord;
  final List<RegistroAsistenciaModel> historyList;
  final VoidCallback? onRegisterExit;
  final String semesterName;
  final num totalRequiredHours;
  final num completedHours;

  const HistorialBody({
    super.key,
    required this.activeRecord,
    required this.historyList,
    this.onRegisterExit,
    this.semesterName = 'Semestre actual',
    this.totalRequiredHours = 0,
    this.completedHours = 0,
  });

  void _showActivitiesDialog(BuildContext context, RegistroAsistenciaModel record) {
    final activities = record.activities;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          title: Row(
            children: [
              const Icon(Icons.list_alt_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Actividades del día',
                  style: AppTextStyles.title.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: activities.isEmpty
                ? const Text('No hay actividades registradas para este día.')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final description = activity['descripcion'] ??
                          activity['description'] ??
                          activity['detalle'] ??
                          'Actividad sin descripción';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                        child: Text(
                          '• $description',
                          style: AppTextStyles.body.copyWith(fontSize: 14),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = totalRequiredHours > 0 ? totalRequiredHours.toDouble() : 1.0;
    final progress = (completedHours.toDouble() / total).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HistorialHeader(
            semesterName: semesterName,
            percentage: percentage,
            completedHours: completedHours.toDouble(),
            totalHours: totalRequiredHours.toDouble(),
          ),
          AppSizes.gapV24,

          ProgresoPracticasCard(
            period: semesterName,
            completedHours: completedHours,
            totalHours: totalRequiredHours > 0 ? totalRequiredHours : completedHours,
          ),
          AppSizes.gapV16,

          if (activeRecord != null) ...[
            SesionActivaCard(
              record: activeRecord!,
              onExitPressed: onRegisterExit ?? () {},
            ),
            AppSizes.gapV16,
          ],

          Text(
            'REGISTROS ANTERIORES',
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: AppColors.textSecondary,
            ),
          ),
          AppSizes.gapV8,

          if (historyList.isEmpty)
            const HistorialEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyList.length,
              separatorBuilder: (context, index) => AppSizes.gapV16,
              itemBuilder: (context, index) {
                final record = historyList[index];
                return HistorialCard(
                  record: record,
                  onDetailPressed: () => _showActivitiesDialog(context, record),
                );
              },
            ),
        ],
      ),
    );
  }
}
