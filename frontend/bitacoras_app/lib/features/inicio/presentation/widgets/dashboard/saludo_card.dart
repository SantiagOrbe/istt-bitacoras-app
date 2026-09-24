import 'package:flutter/material.dart';
import 'package:bitacoras_app/config/constants/app_colors.dart';
import 'package:bitacoras_app/config/constants/app_sizes.dart';
import 'package:bitacoras_app/config/theme/app_text_styles.dart';
import 'package:bitacoras_app/shared/widgets/institutional_glow_card.dart';
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
      case RolUsuarioModel.teacher:
        return "Módulo de docentes y evaluaciones";
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
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.90),
            AppColors.primary.withValues(alpha: 0.78),
          ],
        ),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.34),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.surface.withValues(alpha: 0.14),
            child: const WavingHand(color: AppColors.surface, size: 28),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, $firstName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getSubtitleByRole(),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.surface.withValues(alpha: 0.80),
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
      accentColor: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const WavingHand(
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                AppSizes.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $firstName',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 23,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSizes.gapV4,
                      Text(
                        _getSubtitleByRole(),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
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