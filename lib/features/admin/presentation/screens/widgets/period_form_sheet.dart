import 'package:bitacoras_app/features/admin/domain/models/period_model.dart';
import 'package:bitacoras_app/shared/exports.dart';

class PeriodFormResult {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const PeriodFormResult({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });
}

class PeriodFormSheet extends StatefulWidget {
  final PeriodModel? period;

  const PeriodFormSheet({
    super.key,
    this.period,
  });

  @override
  State<PeriodFormSheet> createState() => _PeriodFormSheetState();
}

class _PeriodFormSheetState extends State<PeriodFormSheet> {
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
    _endDate = widget.period?.endDate ?? DateTime.now().add(const Duration(days: 180));
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
      PeriodFormResult(
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
          child: SingleChildScrollView(
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
                Text(
                  widget.period == null ? 'Nuevo período lectivo' : 'Editar período lectivo',
                  style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary),
                ),
                AppSizes.gapV20,
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del período',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el nombre del período';
                    }
                    return null;
                  },
                ),
                AppSizes.gapV16,
                TextFormField(
                  readOnly: true,
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de inicio',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today_rounded),
                      onPressed: () => _pickDate(isStartDate: true),
                    ),
                  ),
                  onTap: () => _pickDate(isStartDate: true),
                ),
                AppSizes.gapV16,
                TextFormField(
                  readOnly: true,
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de fin',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today_rounded),
                      onPressed: () => _pickDate(isStartDate: false),
                    ),
                  ),
                  onTap: () => _pickDate(isStartDate: false),
                ),
                AppSizes.gapV16,
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
                AppSizes.gapV24,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(widget.period == null ? 'Guardar período' : 'Actualizar período'),
                  ),
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
