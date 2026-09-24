// lib/features/inicio/presentation/widgets/dashboard/estado_card.dart
import 'package:flutter/material.dart';
import 'package:bitacoras_app/config/constants/app_colors.dart';
import 'package:bitacoras_app/config/constants/app_sizes.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
import 'package:bitacoras_app/shared/widgets/institutional_glow_card.dart';

class EstadoCard extends StatelessWidget {
  final RegistroAsistenciaModel? todayRecord;
  final bool isLoading;

  const EstadoCard({super.key, this.todayRecord, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final hasCheckedIn = todayRecord != null && todayRecord!.exitTime == null;
    final hasActivities = todayRecord?.hasActivities ?? false;
    final isCompleted = todayRecord?.exitTime != null;
    final checkInTime = todayRecord?.entryTime ?? 'hora no disponible';

    final statusColor = isCompleted
      ? AppColors.success
      : todayRecord == null
        ? AppColors.warning
        : AppColors.primary;
    final titleText = isLoading
      ? 'CONSULTANDO JORNADA'
      : isCompleted
        ? 'JORNADA COMPLETADA'
        : todayRecord == null
          ? 'ATENCIÓN REQUERIDA'
          : 'JORNADA EN PROCESO';
    final mainDescription = isLoading
      ? 'Cargando estado...'
      : todayRecord == null
        ? 'Sin registro de asistencia'
        : !hasActivities
          ? 'Entrada registrada'
          : !hasCheckedIn
            ? 'Jornada completada'
            : 'Actividades registradas';
    final detailText = isLoading
      ? 'Consultando el registro real del día.'
      : todayRecord == null
        ? 'Usted aún no realiza ningún registro de asistencia.'
        : !hasActivities
          ? 'Entrada marcada a las $checkInTime. Falta registrar sus actividades.'
          : !hasCheckedIn
            ? 'La entrada, actividades y salida de hoy ya fueron registradas.'
            : 'Sus actividades ya fueron registradas. Falta registrar la salida.';
    final statusIcon = isCompleted
      ? Icons.check_circle_rounded
      : todayRecord == null
        ? Icons.warning_amber_rounded
        : Icons.pending_actions_rounded;

    return InstitutionalGlowCard(
      accentColor: statusColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 22),
              const SizedBox(width: 8),
              Text(
                titleText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          AppSizes.gapV8,
          Text(
            mainDescription,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.gapV8,
          Text(
            detailText,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
