import 'package:flutter/material.dart';
import 'package:bitacoras_app/config/constants/app_colores.dart';
import 'package:bitacoras_app/config/constants/app_tamanos.dart';
import 'package:bitacoras_app/config/theme/app_estilo_texto.dart';
import 'package:bitacoras_app/shared/widgets/tarjeta_institucional.dart';
import 'package:bitacoras_app/shared/widgets/waving_hand.dart';
import '../../../domain/models/rol_usuario_model.dart'; // Importamos el enum de roles para las condiciones

class SaludoCard extends StatefulWidget {
  final String name;
  final RolUsuarioModel role;
  final bool lightCard;

  const SaludoCard({
    super.key,
    required this.name,
    required this.role,
    this.lightCard = false,
  });

  @override
  State<SaludoCard> createState() => _SaludoCardState();
}

class _SaludoCardState extends State<SaludoCard> {
  // Método auxiliar para obtener el mensaje adaptado a cada rol
  String _getSubtitleByRole() {
    switch (widget.role) {
      case RolUsuarioModel.student:
        return "Bienvenido a tu jornada de prácticas";
      case RolUsuarioModel.academicTutor:
        return "Panel de seguimiento y tutorías académicas";
      case RolUsuarioModel.companyTutor:
        return "Panel de supervisión del tutor empresarial";
      case RolUsuarioModel.coordinator:
        return "Coordinación y control general de prácticas";
      case RolUsuarioModel.practiceManager:
        return "Gestión de vinculación y responsables de prácticas";
      case RolUsuarioModel.admin:
        return "Consola de administración del sistema";
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.name.split(' ').first;

    if (widget.lightCard) {
      return _buildLightCard(firstName);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTamanos.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColores.primary,
            AppColores.primary.withValues(alpha: 0.90),
            AppColores.primary.withValues(alpha: 0.78),
          ],
        ),
        border: Border.all(
          color: AppColores.secondary.withValues(alpha: 0.34),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColores.primary.withValues(alpha: 0.20),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColores.secondary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColores.surface.withValues(alpha: 0.14),
            child: const WavingHand(color: AppColores.surface, size: 28),
          ),
          const SizedBox(width: AppTamanos.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, $firstName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColores.surface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getSubtitleByRole(),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColores.surface.withValues(alpha: 0.80),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightCard(String firstName) {
    return InstitutionalGlowCard(
      accentColor: AppColores.secondary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Row(
          children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColores.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                  ),
                  child: const WavingHand(
                    color: AppColores.primary,
                    size: 28,
                  ),
                ),
                AppTamanos.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $firstName',
                        style: AppEstiloTexto.heading.copyWith(
                          fontSize: 23,
                          color: AppColores.textPrimary,
                        ),
                      ),
                      AppTamanos.gapV4,
                      Text(
                        _getSubtitleByRole(),
                        style: AppEstiloTexto.body.copyWith(
                          color: AppColores.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}