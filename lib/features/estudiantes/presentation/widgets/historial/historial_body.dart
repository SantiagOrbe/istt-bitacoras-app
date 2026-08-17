import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../../domain/models/registro_asistencia_model.dart';
import 'historial_empty_state.dart';
import 'historial_header.dart';

class HistorialBody extends StatelessWidget {
  final RegistroAsistenciaModel? activeRecord;
  final List<RegistroAsistenciaModel> historyList;
  final VoidCallback? onRegisterExit;

  const HistorialBody({
    super.key,
    required this.activeRecord,
    required this.historyList,
    this.onRegisterExit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HistorialHeader(),
          AppSizes.gapV24,

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
                return HistorialCard(
                  record: historyList[index],
                  onDetailPressed: () {
                    // Navegar al detalle de bitácora
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
