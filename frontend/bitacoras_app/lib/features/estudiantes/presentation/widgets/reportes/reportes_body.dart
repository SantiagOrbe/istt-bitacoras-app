import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class ReportesBody extends StatelessWidget {
  final String period;
  final int completedHours;
  final int totalHours;
  final VoidCallback onGeneratePdf;

  const ReportesBody({
    super.key,
    required this.period,
    required this.completedHours,
    required this.totalHours,
    required this.onGeneratePdf,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ReportesHeader(),
          AppSizes.gapV24,

          ProgresoPracticasCard(
            period: period,
            completedHours: completedHours,
            totalHours: totalHours,
          ),

          AppSizes.gapV16,

          GeneradorPdfCard(onGeneratePressed: onGeneratePdf),

          AppSizes.gapV16,

          Text(
            'Vista Previa del Formato',
            style: AppTextStyles.bodyBold.copyWith(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),

          AppSizes.gapV8,

          const VistaPreviaPdfCard(),
        ],
      ),
    );
  }
}
