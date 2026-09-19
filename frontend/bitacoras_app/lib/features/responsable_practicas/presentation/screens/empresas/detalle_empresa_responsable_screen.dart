import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app/auth_session.dart';
import '../../../../../shared/exports.dart';
import '../../../domain/models/empresa_model.dart';
import '../../../../estudiantes/presentation/widgets/compartidos/mapa_preview.dart';

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
        child: Card(
          elevation: 0,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            side: const BorderSide(color: AppColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.business_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(company.name, style: AppTextStyles.heading)),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Datos reales de la empresa', style: AppTextStyles.bodyBold),
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
