// lib/features/home/presentation/widgets/status_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitacoras_app/config/constants/app_colors.dart';
import 'package:bitacoras_app/features/students/presentation/controllers/attendance_provider.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha automáticamente el estado global de la asistencia
    final provider = context.watch<AttendanceProvider>();
    final hasCheckedIn = provider.hasCheckedIn;
    final checkInTime = provider.checkInTime;

    final statusColor = hasCheckedIn ? AppColors.success : AppColors.warning;
    final titleText = hasCheckedIn ? "JORNADA ACTIVA" : "ATENCIÓN REQUERIDA";
    final mainDescription = hasCheckedIn ? "Entrada Registrada" : "No has registrado entrada";
    final detailText = hasCheckedIn
        ? "Entrada marcada a las ${checkInTime ?? '08:00 AM'}. Recuerda registrar tu salida al finalizar tus actividades."
        : "Debes registrar tu entrada en el centro de prácticas para comenzar a contabilizar tus horas del día de hoy.";
    final statusIcon = hasCheckedIn ? Icons.check_circle_rounded : Icons.warning_amber_rounded;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: statusColor,
            width: 5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
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