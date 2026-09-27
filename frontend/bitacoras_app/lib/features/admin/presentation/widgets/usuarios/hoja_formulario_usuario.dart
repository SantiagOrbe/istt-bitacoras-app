import 'package:bitacoras_app/features/admin/admin.dart';

class HojaFormularioUsuario extends StatefulWidget {
  final IAdminRepository repository;

  const HojaFormularioUsuario({super.key, required this.repository});

  @override
  State<HojaFormularioUsuario> createState() => _HojaFormularioUsuarioState();
}

class _HojaFormularioUsuarioState extends State<HojaFormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _cedula = TextEditingController();
  final _cargo = TextEditingController();
  RolUsuarioModel _role = RolUsuarioModel.student;
  List<EmpresaModel> _companies = [];
  List<CarreraModel> _careers = [];
  String? _companyId;
  String? _careerId;
  bool _mostrarContrasena = false;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      final results = await Future.wait([
        widget.repository.obtenerEmpresas(),
        widget.repository.obtenerCarreras(),
      ]);
      if (!mounted) return;
      setState(() {
        _companies = (results[0] as List<EmpresaModel>)
            .where((item) => item.isActive)
            .toList();
        _careers = (results[1] as List<CarreraModel>)
            .where((item) => item.isActive)
            .toList();
      });
    } catch (_) {
      // The form remains usable; the backend will validate the selection.
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _cedula.dispose();
    _cargo.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      UsuarioModel(
        id: '',
        name: '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim(),
        email: _email.text.trim(),
        role: _role,
        phone: _phone.text.trim(),
        password: _password.text,
        cedula: _cedula.text.trim(),
        cargo: _cargo.text.trim(),
        companyId: _companyId,
        carreraId: _careerId,
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
        padding: EdgeInsets.fromLTRB(
          AppTamanos.md,
          AppTamanos.md,
          AppTamanos.md,
          AppTamanos.md,
        ),
        child: Form(
          key: _formKey,
          child: CuerpoFormularioAdmin(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EncabezadoFormularioAdmin(
                  title: 'Nuevo usuario',
                  subtitle: 'Crea una cuenta y asigna su rol institucional.',
                  icon: Icons.person_add_alt_1_outlined,
                ),
                const EtiquetaSeccionFormularioAdmin('Datos de la cuenta'),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _firstName,
                  etiqueta: 'Nombres',
                  icono: Icons.badge_outlined,
                  validador: (value) =>
                      ValidadoresAdmin.letters(value, label: 'Los nombres'),
                ),
                AppTamanos.gapV8,
                CampoFormularioPrisma(
                  controlador: _lastName,
                  etiqueta: 'Apellidos',
                  icono: Icons.badge_outlined,
                  validador: (value) =>
                      ValidadoresAdmin.letters(value, label: 'Los apellidos'),
                ),
                const EtiquetaSeccionFormularioAdmin('Acceso y permisos'),
                CampoFormularioPrisma(
                  controlador: _email,
                  etiqueta: 'Correo institucional',
                  icono: Icons.email_outlined,
                  tipoTeclado: TextInputType.emailAddress,
                  validador: ValidadoresAdmin.email,
                ),
                AppTamanos.gapV8,
                CampoFormularioPrisma(
                  controlador: _phone,
                  etiqueta: 'Teléfono',
                  textoSugerido: '0991234567 o +593991234567',
                  icono: Icons.phone_outlined,
                  tipoTeclado: TextInputType.phone,
                  validador: ValidadoresAdmin.ecuadorianPhone,
                ),
                AppTamanos.gapV8,
                DropdownButtonFormField<RolUsuarioModel>(
                  initialValue: _role,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: RolUsuarioModel.values
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(
                            role.label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => _changeRole(value ?? _role),
                ),
                if (_role != RolUsuarioModel.admin) ...[
                  AppTamanos.gapV8,
                  CampoFormularioPrisma(
                    controlador: _cedula,
                    etiqueta: 'Cédula',
                    icono: Icons.credit_card_outlined,
                    tipoTeclado: TextInputType.number,
                    validador: ValidadoresAdmin.ecuadorianId,
                  ),
                ],
                if (_role == RolUsuarioModel.student ||
                    _role == RolUsuarioModel.companyTutor) ...[
                  AppTamanos.gapV8,
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _companyId,
                    decoration: const InputDecoration(labelText: 'Empresa'),
                    items: _companies
                        .map(
                          (company) => DropdownMenuItem<String>(
                            value: company.id,
                            child: Text(company.name, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _companyId = value),
                    validator: (value) =>
                        value == null ? 'Selecciona una empresa.' : null,
                  ),
                ],
                if (_role == RolUsuarioModel.student ||
                    _role == RolUsuarioModel.coordinator ||
                    _role == RolUsuarioModel.academicTutor ||
                    _role == RolUsuarioModel.practiceManager) ...[
                  AppTamanos.gapV8,
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _careerId,
                    decoration: const InputDecoration(labelText: 'Carrera'),
                    items: _careers
                        .map(
                          (career) => DropdownMenuItem<String>(
                            value: career.id,
                            child: Text(career.name, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _careerId = value),
                    validator: (value) =>
                        value == null ? 'Selecciona una carrera.' : null,
                  ),
                ],
                if (_role == RolUsuarioModel.companyTutor) ...[
                  AppTamanos.gapV8,
                  CampoFormularioPrisma(
                    controlador: _cargo,
                    etiqueta: 'Cargo',
                    icono: Icons.work_outline,
                    validador: (value) =>
                        ValidadoresAdmin.letters(value, label: 'El cargo'),
                  ),
                ],
                AppTamanos.gapV8,
                CampoFormularioPrisma(
                  controlador: _password,
                  etiqueta: 'Contraseña temporal',
                  icono: Icons.lock_outline_rounded,
                  ocultarTexto: !_mostrarContrasena,
                  accion: IconButton(
                    tooltip: _mostrarContrasena
                        ? 'Ocultar contraseña'
                        : 'Mostrar contraseña',
                    onPressed: () => setState(
                      () => _mostrarContrasena = !_mostrarContrasena,
                    ),
                    icon: Icon(
                      _mostrarContrasena
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                  validador: (value) => (value?.trim().length ?? 0) < 8
                      ? 'Use al menos 8 caracteres.'
                      : null,
                ),
                AppTamanos.gapV16,
                BotonPrisma(
                  texto: 'Crear usuario',
                  icono: Icons.person_add_alt_1,
                  anchoCompleto: true,
                  alPresionar: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeRole(RolUsuarioModel role) {
    setState(() {
      _role = role;
      if (role != RolUsuarioModel.student &&
          role != RolUsuarioModel.coordinator &&
          role != RolUsuarioModel.academicTutor &&
          role != RolUsuarioModel.practiceManager) {
        _careerId = null;
      }
      if (role != RolUsuarioModel.student &&
          role != RolUsuarioModel.academicTutor &&
          role != RolUsuarioModel.companyTutor) {
        _companyId = null;
      }
      if (role != RolUsuarioModel.companyTutor) _cargo.clear();
    });
  }
}
