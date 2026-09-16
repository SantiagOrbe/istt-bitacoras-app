import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/core/network/api_client.dart';

class GestionEmpresaScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const GestionEmpresaScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<GestionEmpresaScreen> createState() => _GestionEmpresaScreenState();
}

class _GestionEmpresaScreenState extends State<GestionEmpresaScreen> {
  List<EmpresaModel> _companies = [];
  bool _isLoading = true;
  bool _showInactive = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() => _isLoading = true);
    try {
      final companies = await widget.adminRepository.getCompanies();
      if (!mounted) return;
      setState(() {
        _companies = companies;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(_errorMessage(error));
    }
  }

  List<EmpresaModel> get _filteredCompanies {
    final query = _query.trim().toLowerCase();
    return _companies.where((company) {
      final matchesStatus = company.isActive != _showInactive;
      final matchesQuery =
          query.isEmpty ||
          company.name.toLowerCase().contains(query) ||
          company.email.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  Future<void> _openForm({EmpresaModel? company}) async {
    final result = await showModalBottomSheet<EmpresaModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EmpresaFormSheet(company: company),
    );
    if (result == null) return;

    try {
      if (company == null) {
        await widget.adminRepository.createCompany(result);
      } else {
        await widget.adminRepository.updateCompany(result);
      }
      await _loadCompanies();
      if (mounted) _showSuccess('Empresa guardada correctamente.');
    } catch (error) {
      if (mounted) _showError(_errorMessage(error));
    }
  }

  Future<void> _toggleStatus(EmpresaModel company) async {
    final action = company.isActive ? 'desactivar' : 'activar';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${company.isActive ? 'Desactivar' : 'Activar'} empresa'),
        content: Text('¿Deseas $action ${company.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(company.isActive ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      if (company.isActive) {
        await widget.adminRepository.deactivateCompany(company.id);
      } else {
        await widget.adminRepository.updateCompany(
          company.copyWith(isActive: true),
        );
      }
      await _loadCompanies();
    } catch (error) {
      if (mounted) _showError(_errorMessage(error));
    }
  }

  String _errorMessage(Object error) {
    if (error is ApiException) return error.message;
    return 'No se pudo completar la operación.';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companies = _filteredCompanies;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
        showBackButton: true,
        onBackPressed: () => context.pop(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business_outlined, color: Colors.white),
        label: const Text('Nueva empresa'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Empresas e instituciones', style: AppTextStyles.heading),
              AppSizes.gapV4,
              Text(
                'Gestiona los lugares disponibles para prácticas.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSizes.gapV16,
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Buscar por nombre o correo',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              AppSizes.gapV12,
              Wrap(
                spacing: AppSizes.sm,
                children: [
                  ChoiceChip(
                    label: const Text('Activas'),
                    selected: !_showInactive,
                    onSelected: (_) => setState(() => _showInactive = false),
                  ),
                  ChoiceChip(
                    label: const Text('Inactivas'),
                    selected: _showInactive,
                    onSelected: (_) => setState(() => _showInactive = true),
                  ),
                ],
              ),
              AppSizes.gapV16,
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : companies.isEmpty
                    ? Center(
                        child: Text(
                          _showInactive
                              ? 'No hay empresas inactivas.'
                              : 'No hay empresas registradas.',
                          style: AppTextStyles.body,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadCompanies,
                        child: ListView.separated(
                          itemCount: companies.length,
                          separatorBuilder: (context, index) => AppSizes.gapV8,
                          itemBuilder: (context, index) {
                            final company = companies[index];
                            return _CompanyTile(
                              company: company,
                              onEdit: () => _openForm(company: company),
                              onToggle: () => _toggleStatus(company),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyTile extends StatelessWidget {
  final EmpresaModel company;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const _CompanyTile({
    required this.company,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = company.isActive ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.infoSoft,
            child: Icon(Icons.business_outlined, color: AppColors.primary),
          ),
          AppSizes.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company.name, style: AppTextStyles.bodyBold),
                Text(company.email, style: AppTextStyles.caption),
                Text(company.phone, style: AppTextStyles.caption),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => value == 'edit' ? onEdit() : onToggle(),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(
                value: 'status',
                child: Text(company.isActive ? 'Desactivar' : 'Activar'),
              ),
            ],
            icon: Icon(Icons.more_vert, color: statusColor),
          ),
        ],
      ),
    );
  }
}

class _EmpresaFormSheet extends StatefulWidget {
  final EmpresaModel? company;

  const _EmpresaFormSheet({this.company});

  @override
  State<_EmpresaFormSheet> createState() => _EmpresaFormSheetState();
}

class _EmpresaFormSheetState extends State<_EmpresaFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _radius;

  @override
  void initState() {
    super.initState();
    final company = widget.company;
    _name = TextEditingController(text: company?.name);
    _address = TextEditingController(text: company?.address);
    _phone = TextEditingController(text: company?.phone);
    _email = TextEditingController(text: company?.email);
    _radius = TextEditingController(text: company?.allowedRadius.toString());
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _email.dispose();
    _radius.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      EmpresaModel(
        id: widget.company?.id ?? '',
        name: _name.text.trim(),
        address: _address.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        allowedRadius: double.parse(_radius.text.trim()),
        isActive: widget.company?.isActive ?? true,
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
                  title: widget.company == null
                      ? 'Nueva empresa'
                      : 'Editar empresa',
                  subtitle:
                      'Registra una institución disponible para prácticas.',
                  icon: Icons.business_outlined,
                ),
                const AdminFormSectionLabel('Información institucional'),
                AppSizes.gapV12,
                TextFormField(
                  controller: _name,
                  validator: (value) => AdminValidators.letters(
                    value,
                    label: 'El nombre de la empresa',
                  ),
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const AdminFormSectionLabel('Contacto y geolocalización'),
                TextFormField(
                  controller: _address,
                  validator: (value) => AdminValidators.requiredText(
                    value,
                    label: 'La dirección',
                  ),
                  decoration: const InputDecoration(labelText: 'Dirección'),
                ),
                AppSizes.gapV8,
                TextFormField(
                  controller: _phone,
                  validator: (value) {
                    final required = AdminValidators.requiredText(
                      value,
                      label: 'El teléfono',
                    );
                    if (required != null) return required;
                    return RegExp(r'^\d{7,15}$').hasMatch(value!.trim())
                        ? null
                        : 'Ingresa entre 7 y 15 dígitos.';
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
                AppSizes.gapV8,
                TextFormField(
                  controller: _email,
                  validator: (value) {
                    return AdminValidators.email(value);
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo'),
                ),
                AppSizes.gapV8,
                TextFormField(
                  controller: _radius,
                  validator: (value) {
                    final radius = double.tryParse(value?.trim() ?? '');
                    return radius != null && radius > 0
                        ? null
                        : 'Ingresa un radio mayor que cero.';
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Radio permitido (metros)',
                  ),
                ),
                AppSizes.gapV16,
                AdminFormActionButton(
                  label: 'Guardar empresa',
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
