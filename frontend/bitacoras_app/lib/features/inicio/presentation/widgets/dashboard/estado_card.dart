// lib/features/inicio/presentation/widgets/dashboard/estado_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitacoras_app/config/constants/app_colors.dart';
import 'package:bitacoras_app/features/estudiantes/presentation/controllers/asistencia_provider.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';

class EstadoCard extends StatelessWidget {
  final RegistroAsistenciaModel? todayRecord;
  final bool isLoading;

  const EstadoCard({super.key, this.todayRecord, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AsistenciaProvider>();
    final hasCheckedIn = todayRecord != null && todayRecord!.exitTime == null;
    final hasActivities = todayRecord?.hasActivities ?? false;
    final isCompleted = todayRecord?.exitTime != null;
    final checkInTime = todayRecord?.entryTime ?? provider.checkInTime?.toString();

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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border(left: BorderSide(color: statusColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
          const SizedBox(height: 10),
          Text(
            mainDescription,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
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
    );
  }
}
