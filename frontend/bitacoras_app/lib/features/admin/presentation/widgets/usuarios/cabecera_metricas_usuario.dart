import 'package:bitacoras_app/features/admin/admin.dart';

class CabeceraMetricasUsuario extends StatelessWidget {
  final int totalUsers;
  final int totalStudents;
  final int totalTutors;
  final int totalActive;

  const CabeceraMetricasUsuario({
    super.key,
    this.totalUsers = 0,
    this.totalStudents = 0,
    this.totalTutors = 0,
    this.totalActive = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildMetricChip('Total', '$totalUsers', AppColores.primary),
          _buildMetricChip('Estudiantes', '$totalStudents', AppColores.primary),
          _buildMetricChip('Tutores', '$totalTutors', AppColores.primary),
          _buildMetricChip('Activos', '$totalActive', AppColores.primary),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, String count, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(right: AppTamanos.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTamanos.md,
        vertical: AppTamanos.sm,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTamanos.radiusPill),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppEstiloTexto.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
          AppTamanos.gapH8,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
            ),
            child: Text(
              count,
              style: AppEstiloTexto.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColores.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
