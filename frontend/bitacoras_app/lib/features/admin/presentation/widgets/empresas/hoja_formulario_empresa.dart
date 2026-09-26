import 'package:bitacoras_app/features/admin/admin.dart';

class HojaFormularioEmpresa extends StatefulWidget {
  final EmpresaModel? empresa;

  const HojaFormularioEmpresa({super.key, this.empresa});

  @override
  State<HojaFormularioEmpresa> createState() => _HojaFormularioEmpresaState();
}

const double _latitudInicialNuevaEmpresa = -0.996298500945855;
const double _longitudInicialNuevaEmpresa = -77.81314070995448;

class _HojaFormularioEmpresaState extends State<HojaFormularioEmpresa> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _canton;
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
    _canton = TextEditingController(text: empresa?.canton ?? '');
    _direccion = TextEditingController(text: empresa?.address);
    _telefono = TextEditingController(text: empresa?.phone);
    _correo = TextEditingController(text: empresa?.email);
    _latitud = empresa?.latitude ?? _latitudInicialNuevaEmpresa;
    _longitud = empresa?.longitude ?? _longitudInicialNuevaEmpresa;
    _radio = empresa?.allowedRadius ?? 50;
    _estaActiva = empresa?.isActive ?? true;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _canton.dispose();
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
        canton: _canton.text.trim(),
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
      color: AppColores.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppTamanos.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Form(
          key: _claveFormulario,
          child: CuerpoFormularioAdmin(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EncabezadoFormularioAdmin(
                  title: widget.empresa == null
                      ? 'Nueva empresa'
                      : 'Editar empresa',
                  subtitle:
                      'Registra una institución disponible para prácticas.',
                  icon: Icons.business_outlined,
                ),
                const EtiquetaSeccionFormularioAdmin(
                  'Información institucional',
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _nombre,
                  etiqueta: 'Nombre',
                  icono: Icons.business_outlined,
                  validador: (value) => ValidadoresAdmin.lettersWithAccents(
                    value,
                    label: 'El nombre de la empresa',
                  ),
                ),
                AppTamanos.gapV8,
                DropdownButtonFormField<String>(
                  initialValue: _canton.text.isEmpty ? null : _canton.text,
                  isExpanded: true,
                  menuMaxHeight: 220,
                  decoration: const InputDecoration(
                    labelText: 'Cantón',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    errorMaxLines: 2,
                  ),
                  items: const [
                    'El Chaco',
                    'Quijos',
                    'Archidona',
                    'Tena',
                    'Arosemena Tola',
                  ]
                      .map(
                        (canton) => DropdownMenuItem<String>(
                          value: canton,
                          child: Text(
                            canton,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _canton.text = value;
                    }
                  },
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Selecciona un cantón.'
                          : null,
                ),
                const EtiquetaSeccionFormularioAdmin(
                  'Contacto y geolocalización',
                ),
                CampoFormularioPrisma(
                  controlador: _direccion,
                  etiqueta: 'Dirección',
                  icono: Icons.location_on_outlined,
                  maxLineas: 2,
                  validador: (value) => ValidadoresAdmin.addressText(
                    value,
                    label: 'La dirección',
                  ),
                ),
                AppTamanos.gapV8,
                CampoFormularioPrisma(
                  controlador: _telefono,
                  etiqueta: 'Teléfono',
                  icono: Icons.phone_outlined,
                  tipoTeclado: TextInputType.phone,
                  validador: (value) {
                    final requerido = ValidadoresAdmin.requiredText(
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
                AppTamanos.gapV8,
                CampoFormularioPrisma(
                  controlador: _correo,
                  etiqueta: 'Correo',
                  icono: Icons.email_outlined,
                  tipoTeclado: TextInputType.emailAddress,
                  validador: (value) {
                    final requerido = ValidadoresAdmin.requiredText(
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
                AppTamanos.gapV16,
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
                AppTamanos.gapV16,
                _EstadoEmpresa(
                  estaActiva: _estaActiva,
                  alCambiar: (valor) => setState(() => _estaActiva = valor),
                ),
                AppTamanos.gapV16,
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
        horizontal: AppTamanos.md,
        vertical: AppTamanos.sm,
      ),
      decoration: BoxDecoration(
        color: estaActiva ? AppColores.successSoft : AppColores.disabledSurface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
        border: Border.all(
          color: estaActiva
              ? AppColores.success.withValues(alpha: 0.35)
              : AppColores.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            estaActiva
                ? Icons.check_circle_outline
                : Icons.pause_circle_outline,
            color: estaActiva ? AppColores.success : AppColores.textSecondary,
          ),
          AppTamanos.gapH8,
          Expanded(
            child: Text(
              estaActiva ? 'Empresa activa' : 'Empresa inactiva',
              style: AppEstiloTexto.bodyMedium,
            ),
          ),
          Switch.adaptive(
            value: estaActiva,
            onChanged: alCambiar,
            activeThumbColor: AppColores.primary,
            activeTrackColor: AppColores.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
