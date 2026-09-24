import 'package:bitacoras_app/features/admin/admin.dart';

class EmpresaFormSheet extends StatefulWidget {
  final EmpresaModel? empresa;

  const EmpresaFormSheet({super.key, this.empresa});

  @override
  State<EmpresaFormSheet> createState() => _EmpresaFormSheetState();
}

class _EmpresaFormSheetState extends State<EmpresaFormSheet> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _direccion;
  late final TextEditingController _telefono;
  late final TextEditingController _correo;
  late double _latitud;
  late double _longitud;
  late double _radio;
  late bool _estaActiva;

  @override
  void initState() {
    super.initState();
    final empresa = widget.empresa;
    _nombre = TextEditingController(text: empresa?.name);
    _direccion = TextEditingController(text: empresa?.address);
    _telefono = TextEditingController(text: empresa?.phone);
    _correo = TextEditingController(text: empresa?.email);
    _latitud = empresa?.latitude ?? -0.1807;
    _longitud = empresa?.longitude ?? -78.4834;
    _radio = empresa?.allowedRadius ?? 50;
    _estaActiva = empresa?.isActive ?? true;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _direccion.dispose();
    _telefono.dispose();
    _correo.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!(_claveFormulario.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      EmpresaModel(
        id: widget.empresa?.id ?? '',
        name: _nombre.text.trim(),
        address: _direccion.text.trim(),
        phone: _telefono.text.trim(),
        email: _correo.text.trim(),
        latitude: _latitud,
        longitude: _longitud,
        allowedRadius: _radio,
        isActive: _estaActiva,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Form(
          key: _claveFormulario,
          child: AdminFormSheetBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminFormHeader(
                  title: widget.empresa == null
                      ? 'Nueva empresa'
                      : 'Editar empresa',
                  subtitle:
                      'Registra una institución disponible para prácticas.',
                  icon: Icons.business_outlined,
                ),
                const AdminFormSectionLabel('Información institucional'),
                AppSizes.gapV12,
                CampoFormularioPrisma(
                  controlador: _nombre,
                  etiqueta: 'Nombre',
                  icono: Icons.business_outlined,
                  validador: (value) => AdminValidators.lettersWithAccents(
                    value,
                    label: 'El nombre de la empresa',
                  ),
                ),
                const AdminFormSectionLabel('Contacto y geolocalización'),
                CampoFormularioPrisma(
                  controlador: _direccion,
                  etiqueta: 'Dirección',
                  icono: Icons.location_on_outlined,
                  maxLineas: 2,
                  validador: (value) =>
                      AdminValidators.addressText(value, label: 'La dirección'),
                ),
                AppSizes.gapV8,
                CampoFormularioPrisma(
                  controlador: _telefono,
                  etiqueta: 'Teléfono',
                  icono: Icons.phone_outlined,
                  tipoTeclado: TextInputType.phone,
                  validador: (value) {
                    final requerido = AdminValidators.requiredText(
                      value,
                      label: 'El teléfono',
                    );
                    if (requerido != null) return requerido;
                    return RegExp(
                          r'^(09\d{8}|\+5939\d{8})$',
                        ).hasMatch(value!.trim())
                        ? null
                        : 'Ingresa un número válido (09XXXXXXXX o +5939XXXXXXXX).';
                  },
                ),
                AppSizes.gapV8,
                CampoFormularioPrisma(
                  controlador: _correo,
                  etiqueta: 'Correo',
                  icono: Icons.email_outlined,
                  tipoTeclado: TextInputType.emailAddress,
                  validador: (value) {
                    final requerido = AdminValidators.requiredText(
                      value,
                      label: 'El correo',
                    );
                    if (requerido != null) return requerido;
                    return RegExp(
                          r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                        ).hasMatch(value!.trim())
                        ? null
                        : 'Ingresa un correo válido con @ y punto.';
                  },
                ),
                AppSizes.gapV16,
                MapaEmpresaSelector(
                  initialLatitude: _latitud,
                  initialLongitude: _longitud,
                  initialRadius: _radio,
                  onLocationChanged: (latitud, longitud) {
                    setState(() {
                      _latitud = latitud;
                      _longitud = longitud;
                    });
                  },
                  onRadiusChanged: (radio) => setState(() => _radio = radio),
                ),
                AppSizes.gapV16,
                _EstadoEmpresa(
                  estaActiva: _estaActiva,
                  alCambiar: (valor) => setState(() => _estaActiva = valor),
                ),
                AppSizes.gapV16,
                BotonPrisma(
                  texto: widget.empresa == null
                      ? 'Guardar empresa'
                      : 'Actualizar empresa',
                  icono: Icons.save_outlined,
                  anchoCompleto: true,
                  alPresionar: _enviar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EstadoEmpresa extends StatelessWidget {
  final bool estaActiva;
  final ValueChanged<bool> alCambiar;

  const _EstadoEmpresa({required this.estaActiva, required this.alCambiar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: estaActiva ? AppColors.successSoft : AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: estaActiva
              ? AppColors.success.withValues(alpha: 0.35)
              : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            estaActiva
                ? Icons.check_circle_outline
                : Icons.pause_circle_outline,
            color: estaActiva ? AppColors.success : AppColors.textSecondary,
          ),
          AppSizes.gapH8,
          Expanded(
            child: Text(
              estaActiva ? 'Empresa activa' : 'Empresa inactiva',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Switch.adaptive(
            value: estaActiva,
            onChanged: alCambiar,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
