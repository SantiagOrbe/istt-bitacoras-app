import 'package:bitacoras_app/app/apps.dart';

class CarreraDetailScreen extends StatefulWidget {
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
  State<CarreraDetailScreen> createState() => _CarreraDetailScreenState();
}

class _CarreraDetailScreenState extends State<CarreraDetailScreen> {
  late CarreraModel _career;

  @override
  void initState() {
    super.initState();
    _career = widget.career;
  }

  Future<void> _toggleStatus() async {
    final willActivate = !_career.isActive;

    if (!willActivate) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Desactivar carrera'),
          content: const Text(
            'Si desactivas esta carrera, dejará de estar disponible para nuevos registros y no podrá seleccionarse en formularios activos. Esto incluye semestres y estudiantes asociados.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    final updated = _career.copyWith(isActive: willActivate);
    try {
      await widget.adminRepository.updateCareer(
        updated,
        confirmDesactivate: !willActivate,
      );
      if (!mounted) return;
      setState(() => _career = updated);
      if (mounted) {
        Navigator.pop(context, updated);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            willActivate ? 'Carrera activada.' : 'Carrera desactivada.',
          ),
          backgroundColor: willActivate ? AppColors.success : AppColors.error,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
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
                            career: _career,
                            existingCareers: [_career],
                          ),
                        );
                        if (updated == null || !context.mounted) return;

                        try {
                          await widget.adminRepository.updateCareer(
                            updated,
                            confirmDesactivate: !updated.isActive && _career.isActive,
                          );
                          if (context.mounted) {
                            setState(() => _career = updated);
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
                  _career.name,
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSizes.gapV8,
                Text(
                  'ID: ${_career.id}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSizes.gapV16,
                _InfoRow(label: 'Código', value: _career.code),
                AppSizes.gapV16,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.semesterManagement.replaceFirst(
                        ':carreraId',
                        _career.id,
                      ),
                    ),
                    icon: const Icon(Icons.layers_outlined),
                    label: const Text('Semestres'),
                  ),
                ),
                AppSizes.gapV8,
                _InfoRow(label: 'Sigla', value: _career.shortName),
                AppSizes.gapV8,
                _InfoRow(label: 'Modalidad', value: _career.modality),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Semestres totales',
                  value: _career.totalSemesters.toString(),
                ),
                AppSizes.gapV8,
                _InfoRow(
                  label: 'Estado',
                  value: _career.isActive ? 'Activa' : 'Inactiva',
                ),
                AppSizes.gapV8,
                Text(
                  _career.description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSizes.gapV16,
                FilledButton.icon(
                  onPressed: _toggleStatus,
                  icon: Icon(
                    _career.isActive
                        ? Icons.block_flipped
                        : Icons.check_circle_outline,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _career.isActive
                        ? AppColors.error
                        : AppColors.success,
                  ),
                  label: Text(
                    _career.isActive ? 'Desactivar carrera' : 'Activar carrera',
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
