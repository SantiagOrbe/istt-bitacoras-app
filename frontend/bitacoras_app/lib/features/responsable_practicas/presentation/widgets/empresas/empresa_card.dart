import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


class EmpresaCard extends StatelessWidget {
  final EmpresaModel company;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;

  const EmpresaCard({
    super.key,
    required this.company,
    this.onTap,
    this.onEdit,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = company.isActive;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: AppSizes.md),
      child: InstitutionalGlowCard(
        accentColor: isActive ? AppColors.secondary : AppColors.textSecondary,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
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
                          company.address.isEmpty
                              ? 'Dirección no registrada'
                              : company.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
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
              _CompanyDataRow(
                icon: Icons.phone_outlined,
                value: company.phone.isEmpty ? 'Teléfono no registrado' : company.phone,
              ),
              const SizedBox(height: 6),
              _CompanyDataRow(
                icon: Icons.email_outlined,
                value: company.email.isEmpty ? 'Correo no registrado' : company.email,
              ),
              const SizedBox(height: 6),
              _CompanyDataRow(
                icon: Icons.radar_outlined,
                value: 'Radio permitido: ${company.allowedRadius.toStringAsFixed(0)} m',
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

class _CompanyDataRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _CompanyDataRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}