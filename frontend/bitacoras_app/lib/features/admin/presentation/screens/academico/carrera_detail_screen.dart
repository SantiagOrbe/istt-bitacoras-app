import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
import 'package:bitacoras_app/features/admin/domain/repositories/i_admin_repository.dart';
import 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_form_sheet.dart';

class CarreraDetailScreen extends StatelessWidget {
  final UsuarioModel currentUser;
  final CarreraModel career;
  final IAdminRepository adminRepository;

  const CarreraDetailScreen({
    super.key,
    required this.currentUser,
    required this.career,
    required this.adminRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: currentUser,
        showBackButton: true,
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.account_tree_rounded,
                      color: AppColors.primary,
                      size: 36,
                    ),
                    IconButton(
                      tooltip: 'Editar carrera',
                      icon: const Icon(Icons.edit_outlined),
                      color: AppColors.primary,
                      onPressed: () async {
                        final updated = await showModalBottomSheet<CarreraModel>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => CarreraFormSheet(
                            career: career,
                            existingCareers: [career],
                          ),
                        );
                        if (updated == null || !context.mounted) return;
                        try {
                          await adminRepository.updateCareer(updated);
                          if (context.mounted) {
                            context.pop(updated);
                          }
                        } catch (error) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        }
                      },
                    ),
                  ],
                ),
                AppSizes.gapV12,
                Text(
                  career.name,
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSizes.gapV8,
                Text(
                  'ID: ${career.id}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSizes.gapV16,
                _InfoRow(label: 'Código', value: career.code),
                AppSizes.gapV16,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.semesterManagement.replaceFirst(
                        ':carreraId',
                        career.id,
                      ),
                    ),
                    icon: const Icon(Icons.layers_outlined),
                    label: const Text('Semestres'),
                  ),
                ),
                AppSizes.gapV8,
                _InfoRow(label: 'Sigla', value: career.shortName),
                AppSizes.gapV8,
                _InfoRow(label: 'Modalidad', value: career.modality),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Semestres totales',
                  value: career.totalSemesters.toString(),
                ),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Estado',
                  value: career.isActive ? 'Activa' : 'Inactiva',
                ),
                AppSizes.gapV8,
                Text(
                  career.description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
