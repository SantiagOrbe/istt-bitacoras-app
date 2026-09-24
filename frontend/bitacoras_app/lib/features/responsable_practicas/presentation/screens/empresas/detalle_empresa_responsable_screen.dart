import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


class DetalleEmpresaResponsableScreen extends StatelessWidget {
  final EmpresaModel company;

  const DetalleEmpresaResponsableScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: context.read<AuthSession>().currentUser!,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: InstitutionalGlowCard(
          accentColor: company.isActive ? AppColors.secondary : AppColors.textSecondary,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: const Icon(
                        Icons.business_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(company.name, style: AppTextStyles.heading)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Información de la empresa',
                        style: AppTextStyles.bodyBold,
                      ),
                    ),
                    _StatusBadge(isActive: company.isActive),
                  ],
                ),
                const SizedBox(height: 14),
                _Info(label: 'Dirección', value: company.address),
                _Info(label: 'Teléfono', value: company.phone),
                _Info(label: 'Correo', value: company.email),
                _Info(label: 'Radio permitido', value: '${company.allowedRadius.toStringAsFixed(0)} m'),
                const SizedBox(height: 18),
                Text('Ubicación geográfica', style: AppTextStyles.bodyBold),
                const SizedBox(height: 10),
                MapaPreview(
                  latitude: company.latitude,
                  longitude: company.longitude,
                  radiusInMeters: company.allowedRadius,
                  isGpsActive: true,
                  statusLabel: 'Ubicación de la empresa',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;

  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value.isEmpty ? 'No registrado' : value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        isActive ? 'Activa' : 'Inactiva',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
