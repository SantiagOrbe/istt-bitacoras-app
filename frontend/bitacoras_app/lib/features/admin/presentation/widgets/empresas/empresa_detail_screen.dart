import 'package:bitacoras_app/features/admin/admin.dart';

class EmpresaDetailScreen extends StatefulWidget {
  final UsuarioModel usuarioActual;
  final IAdminRepository repositorio;
  final EmpresaModel empresa;

  const EmpresaDetailScreen({
    super.key,
    required this.usuarioActual,
    required this.repositorio,
    required this.empresa,
  });

  @override
  State<EmpresaDetailScreen> createState() => _EmpresaDetailScreenState();
}

class _EmpresaDetailScreenState extends State<EmpresaDetailScreen> {
  late EmpresaModel _empresa;

  @override
  void initState() {
    super.initState();
    _empresa = widget.empresa;
  }

  Future<void> _editar() async {
    final resultado = await showModalBottomSheet<EmpresaModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EmpresaFormSheet(empresa: _empresa),
    );
    if (resultado == null) return;

    try {
      await widget.repositorio.updateCompany(resultado);
      if (!mounted) return;
      Navigator.pop(context, resultado);
    } catch (_) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo guardar la empresa.', AppColors.error);
    }
  }

  Future<void> _alternarEstado() async {
    final activar = !_empresa.isActive;
    if (!activar) {
      final vinculados = await widget.repositorio.getCompanyLinkedStudents(
        _empresa.id,
      );
      if (vinculados.isNotEmpty && mounted) {
        final confirmado = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Desactivar empresa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Si inactivas esta empresa, se eliminarán los enlaces con los estudiantes asociados.',
                ),
                AppSizes.gapV12,
                Text('Estudiantes vinculados:', style: AppTextStyles.bodyBold),
                AppSizes.gapV8,
                ...vinculados.map(
                  (estudiante) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        AppSizes.gapH8,
                        Expanded(
                          child: Text(
                            estudiante['nombre']?.isNotEmpty == true
                                ? estudiante['nombre']!
                                : 'Estudiante sin nombre',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
        if (confirmado != true) return;
      }

      try {
        await widget.repositorio.deactivateCompany(
          _empresa.id,
          unlinkStudents: true,
        );
        if (!mounted) return;
        Navigator.pop(context, _empresa.copyWith(isActive: false));
      } catch (_) {
        if (mounted) {
          _mostrarMensaje('No se pudo desactivar la empresa.', AppColors.error);
        }
      }
      return;
    }

    try {
      final actualizada = _empresa.copyWith(isActive: true);
      await widget.repositorio.updateCompany(actualizada);
      if (!mounted) return;
      Navigator.pop(context, actualizada);
    } catch (_) {
      if (mounted) {
        _mostrarMensaje('No se pudo activar la empresa.', AppColors.error);
      }
    }
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final colorEstado = _empresa.isActive ? AppColors.success : AppColors.error;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: widget.usuarioActual,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context, _empresa),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.secondary, AppColors.warning],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: const Icon(
                        Icons.business_outlined,
                        color: AppColors.surface,
                        size: 26,
                      ),
                    ),
                    AppSizes.gapH12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalle de empresa',
                            style: AppTextStyles.title,
                          ),
                          Text(
                            _empresa.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSizes.gapV20,
              _InfoEmpresa(label: 'Nombre', value: _empresa.name),
              AppSizes.gapV12,
              _InfoEmpresa(label: 'Dirección', value: _empresa.address),
              AppSizes.gapV12,
              _InfoEmpresa(label: 'Teléfono', value: _empresa.phone),
              AppSizes.gapV12,
              _InfoEmpresa(label: 'Correo', value: _empresa.email),
              AppSizes.gapV12,
              _InfoEmpresa(
                label: 'Ubicación',
                value: '${_empresa.latitude}, ${_empresa.longitude}',
              ),
              AppSizes.gapV12,
              _InfoEmpresa(
                label: 'Radio permitido',
                value: '${_empresa.allowedRadius.toStringAsFixed(0)} m',
              ),
              AppSizes.gapV20,
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: colorEstado.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Estado de la empresa',
                        style: AppTextStyles.bodyBold,
                      ),
                    ),
                    Text(
                      _empresa.isActive ? 'Activa' : 'Inactiva',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: colorEstado,
                      ),
                    ),
                  ],
                ),
              ),
              AppSizes.gapV20,
              BotonPrisma(
                texto: 'Editar información',
                icono: Icons.edit_outlined,
                anchoCompleto: true,
                alPresionar: _editar,
              ),
              AppSizes.gapV12,
              BotonPrisma(
                texto: _empresa.isActive
                    ? 'Desactivar empresa'
                    : 'Activar empresa',
                icono: _empresa.isActive
                    ? Icons.block_flipped
                    : Icons.check_circle_outline,
                anchoCompleto: true,
                alPresionar: _alternarEstado,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoEmpresa extends StatelessWidget {
  final String label;
  final String value;

  const _InfoEmpresa({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          AppSizes.gapV4,
          Text(value, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }
}
