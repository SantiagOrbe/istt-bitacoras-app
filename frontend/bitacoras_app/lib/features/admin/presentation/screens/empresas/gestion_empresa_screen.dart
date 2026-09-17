import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/core/network/api_client.dart';
import 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/mapa_empresa_selector.dart';

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
  bool? _statusFilter;
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
      final matchesStatus = _statusFilter == null
          ? true
          : company.isActive == (_statusFilter == false);
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

  Future<void> _openCompanyDetail(EmpresaModel company) async {
    final result = await Navigator.push<EmpresaModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EmpresaDetailScreen(
          currentUser: widget.currentUser,
          adminRepository: widget.adminRepository,
          company: company,
        ),
      ),
    );

    if (result != null) {
      await _loadCompanies();
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Todos',
                      selected: _statusFilter == null,
                      onSelected: (_) => setState(() => _statusFilter = null),
                    ),
                    _FilterChip(
                      label: 'Activas',
                      selected: _statusFilter == false,
                      onSelected: (_) => setState(() => _statusFilter = false),
                    ),
                    _FilterChip(
                      label: 'Inactivas',
                      selected: _statusFilter == true,
                      onSelected: (_) => setState(() => _statusFilter = true),
                    ),
                  ],
                ),
              ),
              AppSizes.gapV16,
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : companies.isEmpty
                    ? Center(
                        child: Text(
                          _statusFilter == true
                              ? 'No hay empresas inactivas.'
                              : _statusFilter == false
                              ? 'No hay empresas activas.'
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
                              onOpen: () => _openCompanyDetail(company),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        backgroundColor: AppColors.surface,
        labelStyle: AppTextStyles.body.copyWith(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outline,
        ),
      ),
    );
  }
}

class _CompanyTile extends StatelessWidget {
  final EmpresaModel company;
  final VoidCallback onOpen;

  const _CompanyTile({
    required this.company,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = company.isActive ? AppColors.success : AppColors.error;
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                company.isActive ? 'Activa' : 'Inactiva',
                style: AppTextStyles.caption.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmpresaDetailScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;
  final EmpresaModel company;

  const EmpresaDetailScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
    required this.company,
  });

  @override
  State<EmpresaDetailScreen> createState() => _EmpresaDetailScreenState();
}

class _EmpresaDetailScreenState extends State<EmpresaDetailScreen> {
  late EmpresaModel _company;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
  }

  Future<void> _openEditForm() async {
    final result = await showModalBottomSheet<EmpresaModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EmpresaFormSheet(company: _company),
    );

    if (result == null) return;

    setState(() => _company = result);
    try {
      await widget.adminRepository.updateCompany(result);
      if (!mounted) return;
      Navigator.pop(context, result);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la empresa.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _toggleStatus() async {
    final willActivate = !_company.isActive;
    if (!willActivate) {
      final linked = await widget.adminRepository.getCompanyLinkedStudents(_company.id);
      if (linked.isNotEmpty && mounted) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Desactivar empresa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Si inactivas esta empresa, se eliminarán los enlaces con los estudiantes que están asociados a ella.',
                ),
                AppSizes.gapV12,
                Text(
                  'Estudiantes vinculados:',
                  style: AppTextStyles.bodyBold,
                ),
                AppSizes.gapV8,
                ...linked.map(
                  (student) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        AppSizes.gapH8,
                        Expanded(
                          child: Text(
                            student['nombre']?.isNotEmpty == true
                                ? student['nombre']!
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
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Continuar'),
              ),
            ],
          ),
        );

        if (confirmed != true) return;
      }

      try {
        await widget.adminRepository.deactivateCompany(_company.id, unlinkStudents: true);
        if (!mounted) return;
        final updated = _company.copyWith(isActive: false);
        setState(() => _company = updated);
        if (mounted) Navigator.pop(context, updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Empresa desactivada.'),
            backgroundColor: AppColors.error,
          ),
        );
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo desactivar la empresa.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    try {
      final updated = _company.copyWith(isActive: true);
      await widget.adminRepository.updateCompany(updated);
      if (!mounted) return;
      setState(() => _company = updated);
      if (mounted) Navigator.pop(context, updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Empresa activada.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo activar la empresa.'),
          backgroundColor: AppColors.error,
        ),
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
        onBackPressed: () => Navigator.pop(context, _company),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalle de empresa', style: AppTextStyles.heading),
              AppSizes.gapV8,
              Text(
                'Revisa los datos de la empresa y cambia su estado.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSizes.gapV20,
              _InfoCard(label: 'Nombre', value: _company.name),
              AppSizes.gapV12,
              _InfoCard(label: 'Dirección', value: _company.address),
              AppSizes.gapV12,
              _InfoCard(label: 'Teléfono', value: _company.phone),
              AppSizes.gapV12,
              _InfoCard(label: 'Correo', value: _company.email),
              AppSizes.gapV12,
              _InfoCard(
                label: 'Ubicación',
                value: '${_company.latitude}, ${_company.longitude}',
              ),
              AppSizes.gapV12,
              _InfoCard(
                label: 'Radio permitido',
                value: '${_company.allowedRadius.toStringAsFixed(0)} m',
              ),
              AppSizes.gapV20,
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estado de la empresa',
                            style: AppTextStyles.bodyBold,
                          ),
                          AppSizes.gapV4,
                          Text(
                            _company.isActive ? 'Activa' : 'Inactiva',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _company.isActive
                            ? AppColors.success.withValues(alpha: 0.12)
                            : AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _company.isActive ? 'Activa' : 'Inactiva',
                        style: AppTextStyles.caption.copyWith(
                          color: _company.isActive
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSizes.gapV20,
              FilledButton.icon(
                onPressed: _openEditForm,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar información'),
              ),
              AppSizes.gapV12,
              FilledButton.icon(
                onPressed: _toggleStatus,
                icon: Icon(
                  _company.isActive ? Icons.block_flipped : Icons.check_circle_outline,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _company.isActive
                      ? AppColors.error
                      : AppColors.success,
                ),
                label: Text(
                  _company.isActive ? 'Desactivar empresa' : 'Activar empresa',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.outline),
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
  late double _latitude;
  late double _longitude;
  late double _radius;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final company = widget.company;
    _name = TextEditingController(text: company?.name);
    _address = TextEditingController(text: company?.address);
    _phone = TextEditingController(text: company?.phone);
    _email = TextEditingController(text: company?.email);
    _latitude = company?.latitude ?? -0.1807;
    _longitude = company?.longitude ?? -78.4834;
    _radius = company?.allowedRadius ?? 50;
    _isActive = company?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _email.dispose();
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
        latitude: _latitude,
        longitude: _longitude,
        allowedRadius: _radius,
        isActive: _isActive,
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
                  validator: (value) => AdminValidators.lettersWithAccents(
                    value,
                    label: 'El nombre de la empresa',
                  ),
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const AdminFormSectionLabel('Contacto y geolocalización'),
                TextFormField(
                  controller: _address,
                  validator: (value) => AdminValidators.addressText(
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
                    return RegExp(r'^(09\d{8}|\+5939\d{8})$').hasMatch(value!.trim())
                        ? null
                        : 'Ingresa un número válido (09XXXXXXXX o +5939XXXXXXXX).';
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
                AppSizes.gapV8,
                TextFormField(
                  controller: _email,
                  validator: (value) {
                    final required = AdminValidators.requiredText(
                      value,
                      label: 'El correo',
                    );
                    if (required != null) return required;
                    return RegExp(
                      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                    ).hasMatch(value!.trim())
                        ? null
                        : 'Ingresa un correo válido con @ y punto, '
                            'por ejemplo nombre@empresa.com.';
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo'),
                ),
                AppSizes.gapV16,
                MapaEmpresaSelector(
                  initialLatitude: _latitude,
                  initialLongitude: _longitude,
                  initialRadius: _radius,
                  onLocationChanged: (lat, lng) {
                    setState(() {
                      _latitude = lat;
                      _longitude = lng;
                    });
                  },
                  onRadiusChanged: (radius) {
                    setState(() => _radius = radius);
                  },
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
