import 'package:flutter/material.dart';
import '../../../../config/constants/app_colors.dart';
import '../../domain/models/company_model.dart';

class CompanyCard extends StatelessWidget {
  final CompanyModel company;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;

  const CompanyCard({
    super.key,
    required this.company,
    this.onTap,
    this.onEdit,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = company.isActive;

    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.business_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'RUC: ${company.ruc}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge de Estado Institucional
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.successSoft : AppColors.errorSoft,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? AppColors.success : AppColors.error,
                      ),
                    ),
                    child: Text(
                      isActive ? 'Activa' : 'Inactiva',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isActive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.divider, height: 24),
              Text(
                'Representante: ${company.legalRepresentative}',
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                'Convenio: ${company.agreementNumber}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                      label: const Text('Editar', style: TextStyle(color: AppColors.primary)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (onToggleStatus != null)
                    OutlinedButton.icon(
                      onPressed: onToggleStatus,
                      icon: Icon(
                        isActive ? Icons.block_outlined : Icons.check_circle_outline,
                        size: 16,
                        color: isActive ? AppColors.error : AppColors.success,
                      ),
                      label: Text(
                        isActive ? 'Desactivar' : 'Activar',
                        style: TextStyle(
                          color: isActive ? AppColors.error : AppColors.success,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isActive ? AppColors.error : AppColors.success,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}