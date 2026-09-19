import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/core/network/api_client.dart';

class GestionUsuarioScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const GestionUsuarioScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<GestionUsuarioScreen> createState() => _GestionUsuarioScreenState();
}

class _GestionUsuarioScreenState extends State<GestionUsuarioScreen> {
  late final GestionUsuarioController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GestionUsuarioController(repository: widget.adminRepository);
    _controller.fetchUsers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openUserForm() async {
    final user = await showModalBottomSheet<UsuarioModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UsuarioFormSheet(repository: widget.adminRepository),
    );
    if (user == null) return;

    try {
      await widget.adminRepository.createUser(user);
      await _controller.fetchUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado correctamente.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      final message = error is ApiException
          ? error.message
          : 'No se pudo crear el usuario.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openUserForm,
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: Text(
              'Nuevo Usuario',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.surface),
            ),
          ),
          body: SafeArea(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GestionUsuarioBody(
                    users: _controller.filteredUsers,
                    totalUsers: _controller.totalUsers,
                    totalStudents: _controller.totalStudents,
                    totalTutors: _controller.totalTutors,
                    totalActive: _controller.totalActive,
                    onUserTap: (user) => context
                        .push(AppRoutes.userDetail, extra: user)
                        .then((updatedUser) {
                          if (updatedUser is UsuarioModel) {
                            _controller.updateUserLocally(updatedUser);
                          }
                        }),
                    onSearchChanged: _controller.setSearchQuery,
                    roleFilter: _controller.roleFilter,
                    activeFilter: _controller.activeFilter,
                    onRoleChanged: _controller.setRoleFilter,
                    onActiveChanged: _controller.setActiveFilter,
                  ),
          ),
        );
      },
    );
  }
}

class _UsuarioFormSheet extends StatefulWidget {
  final IAdminRepository repository;

  const _UsuarioFormSheet({required this.repository});

  @override
  State<_UsuarioFormSheet> createState() => _UsuarioFormSheetState();
}

class _UsuarioFormSheetState extends State<_UsuarioFormSheet> {
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

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      final results = await Future.wait([
        widget.repository.getCompanies(),
        widget.repository.getCareers(),
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
      color: AppColors.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
        ),
        child: Form(
          key: _formKey,
          child: AdminFormSheetBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminFormHeader(
                  title: 'Nuevo usuario',
                  subtitle: 'Crea una cuenta y asigna su rol institucional.',
                  icon: Icons.person_add_alt_1_outlined,
                ),
                const AdminFormSectionLabel('Datos de la cuenta'),
                AppSizes.gapV12,
                TextFormField(
                  controller: _firstName,
                  validator: (value) =>
                      AdminValidators.letters(value, label: 'Los nombres'),
                  decoration: const InputDecoration(
                    labelText: 'Nombres',
                    errorMaxLines: 2,
                  ),
                ),
                AppSizes.gapV8,
                TextFormField(
                  controller: _lastName,
                  validator: (value) =>
                      AdminValidators.letters(value, label: 'Los apellidos'),
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
                    errorMaxLines: 2,
                  ),
                ),
                const AdminFormSectionLabel('Acceso y permisos'),
                TextFormField(
                  controller: _email,
                  validator: (value) {
                    return AdminValidators.email(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Correo institucional',
                    errorMaxLines: 2,
                  ),
                ),
                AppSizes.gapV8,
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  validator: AdminValidators.ecuadorianPhone,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    hintText: 'Ej: 0991234567 o +593991234567',
                    errorMaxLines: 2,
                  ),
                ),
                AppSizes.gapV8,
                DropdownButtonFormField<RolUsuarioModel>(
                  initialValue: _role,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: RolUsuarioModel.values
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => _changeRole(value ?? _role),
                ),
                if (_role != RolUsuarioModel.admin) ...[
                  AppSizes.gapV8,
                  TextFormField(
                    controller: _cedula,
                    validator: (value) {
                      return AdminValidators.ecuadorianId(value);
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cédula',
                      errorMaxLines: 2,
                    ),
                  ),
                ],
                if (_role == RolUsuarioModel.student ||
                    _role == RolUsuarioModel.companyTutor) ...[
                  AppSizes.gapV8,
                  DropdownButtonFormField<String>(
                    initialValue: _companyId,
                    decoration: const InputDecoration(labelText: 'Empresa'),
                    items: _companies
                        .map(
                          (company) => DropdownMenuItem<String>(
                            value: company.id,
                            child: Text(company.name),
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
                  AppSizes.gapV8,
                  DropdownButtonFormField<String>(
                    initialValue: _careerId,
                    decoration: const InputDecoration(labelText: 'Carrera'),
                    items: _careers
                        .map(
                          (career) => DropdownMenuItem<String>(
                            value: career.id,
                            child: Text(career.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _careerId = value),
                    validator: (value) =>
                        value == null ? 'Selecciona una carrera.' : null,
                  ),
                ],
                if (_role == RolUsuarioModel.companyTutor) ...[
                  AppSizes.gapV8,
                  TextFormField(
                    controller: _cargo,
                    validator: (value) =>
                        AdminValidators.letters(value, label: 'El cargo'),
                    decoration: const InputDecoration(labelText: 'Cargo'),
                  ),
                ],
                AppSizes.gapV8,
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (value) => (value?.trim().length ?? 0) < 8
                      ? 'Use al menos 8 caracteres.'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña temporal',
                  ),
                ),
                AppSizes.gapV16,
                AdminFormActionButton(
                  label: 'Crear usuario',
                  onPressed: _submit,
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
