import 'package:bitacoras_app/features/admin/admin.dart';

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

class HojaFormularioPeriodo extends StatefulWidget {
  final PeriodoModel? period;

  const HojaFormularioPeriodo({super.key, this.period});

  @override
  State<HojaFormularioPeriodo> createState() => _HojaFormularioPeriodoState();
}

class _HojaFormularioPeriodoState extends State<HojaFormularioPeriodo> {
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
        padding: const EdgeInsets.all(AppTamanos.lg),
        decoration: const BoxDecoration(
          color: AppColores.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: CuerpoFormularioAdmin(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColores.outline,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                AppTamanos.gapV20,
                EncabezadoFormularioAdmin(
                  title: widget.period == null
                      ? 'Nuevo período lectivo'
                      : 'Editar período lectivo',
                  subtitle: 'Define las fechas y vigencia del período.',
                  icon: Icons.calendar_month_outlined,
                ),
                const EtiquetaSeccionFormularioAdmin('Datos del período'),
                CampoFormularioPrisma(
                  controlador: _nameController,
                  etiqueta: 'Nombre del período',
                  icono: Icons.calendar_month_outlined,
                  capitalizacion: TextCapitalization.words,
                  validador: (value) {
                    return ValidadoresAdmin.requiredText(
                      value,
                      label: 'El nombre del período',
                    );
                  },
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _startDateController,
                  etiqueta: 'Fecha de inicio',
                  icono: Icons.event_available_outlined,
                  soloLectura: true,
                  alPresionar: () => _pickDate(isStartDate: true),
                  accion: IconButton(
                    icon: const Icon(Icons.calendar_today_rounded),
                    onPressed: () => _pickDate(isStartDate: true),
                  ),
                  validador: (value) => value == null || value.isEmpty
                      ? 'Selecciona la fecha de inicio'
                      : null,
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _endDateController,
                  etiqueta: 'Fecha de fin',
                  icono: Icons.event_busy_outlined,
                  soloLectura: true,
                  alPresionar: () => _pickDate(isStartDate: false),
                  accion: IconButton(
                    icon: const Icon(Icons.calendar_today_rounded),
                    onPressed: () => _pickDate(isStartDate: false),
                  ),
                  validador: (value) => value == null || value.isEmpty
                      ? 'Selecciona la fecha de fin'
                      : null,
                ),
                const EtiquetaSeccionFormularioAdmin('Estado'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTamanos.md,
                    vertical: AppTamanos.sm,
                  ),
                  decoration: BoxDecoration(
                    color: _isActive
                        ? AppColores.successSoft
                        : AppColores.disabledSurface,
                    borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                    border: Border.all(
                      color: _isActive
                          ? AppColores.success.withValues(alpha: 0.35)
                          : AppColores.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isActive
                            ? Icons.check_circle_outline
                            : Icons.pause_circle_outline,
                        color: _isActive
                            ? AppColores.success
                            : AppColores.textSecondary,
                      ),
                      AppTamanos.gapH8,
                      Expanded(
                        child: Text(
                          _isActive ? 'Período activo' : 'Período inactivo',
                          style: AppEstiloTexto.bodyMedium,
                        ),
                      ),
                      Switch.adaptive(
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                        activeThumbColor: AppColores.primary,
                        activeTrackColor: AppColores.primary.withValues(
                          alpha: 0.35,
                        ),
                      ),
                    ],
                  ),
                ),
                AppTamanos.gapV20,
                BotonPrisma(
                  texto: widget.period == null
                      ? 'Guardar período'
                      : 'Actualizar período',
                  icono: Icons.save_outlined,
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
