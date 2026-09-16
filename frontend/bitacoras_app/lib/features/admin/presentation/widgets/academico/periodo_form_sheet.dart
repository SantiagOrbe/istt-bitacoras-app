import 'package:bitacoras_app/features/admin/domain/models/periodo_model.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../admin_form_components.dart';

class PeriodoFormResult {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const PeriodoFormResult({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });
}

class PeriodoFormSheet extends StatefulWidget {
  final PeriodoModel? period;

  const PeriodoFormSheet({super.key, this.period});

  @override
  State<PeriodoFormSheet> createState() => _PeriodoFormSheetState();
}

class _PeriodoFormSheetState extends State<PeriodoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.period?.name ?? '');
    _startDate = widget.period?.startDate ?? DateTime.now();
    _endDate =
        widget.period?.endDate ?? DateTime.now().add(const Duration(days: 180));
    _isActive = widget.period?.isActive ?? true;
    _startDateController = TextEditingController(text: _formatDate(_startDate));
    _endDateController = TextEditingController(text: _formatDate(_endDate));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isStartDate) {
        _startDate = picked;
        _startDateController.text = _formatDate(_startDate);
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
          _endDateController.text = _formatDate(_endDate);
        }
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(_endDate);
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      PeriodoFormResult(
        name: _nameController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 48),
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: AdminFormSheetBody(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                AppSizes.gapV20,
                AdminFormHeader(
                  title: widget.period == null
                      ? 'Nuevo período lectivo'
                      : 'Editar período lectivo',
                  subtitle: 'Define las fechas y vigencia del período.',
                  icon: Icons.calendar_month_outlined,
                ),
                const AdminFormSectionLabel('Datos del período'),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del período',
                  ),
                  validator: (value) {
                    return AdminValidators.requiredText(
                      value,
                      label: 'El nombre del período',
                    );
                  },
                ),
                AppSizes.gapV12,
                TextFormField(
                  readOnly: true,
                  controller: _startDateController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona la fecha de inicio'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Fecha de inicio',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today_rounded),
                      onPressed: () => _pickDate(isStartDate: true),
                    ),
                  ),
                  onTap: () => _pickDate(isStartDate: true),
                ),
                AppSizes.gapV12,
                TextFormField(
                  readOnly: true,
                  controller: _endDateController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Selecciona la fecha de fin'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Fecha de fin',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today_rounded),
                      onPressed: () => _pickDate(isStartDate: false),
                    ),
                  ),
                  onTap: () => _pickDate(isStartDate: false),
                ),
                const AdminFormSectionLabel('Estado'),
                SwitchListTile.adaptive(
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                  title: const Text('Período activo'),
                  contentPadding: EdgeInsets.zero,
                ),
                AppSizes.gapV20,
                AdminFormActionButton(
                  label: widget.period == null
                      ? 'Guardar período'
                      : 'Actualizar período',
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
