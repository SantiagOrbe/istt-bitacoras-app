import 'package:bitacoras_app/features/admin/admin.dart';

class CicloFormResult {
  final String name;
  final String careerId;
  final int level;
  final int hoursPracticas;
  final bool isActive;

  const CicloFormResult({
    required this.name,
    required this.careerId,
    required this.level,
    required this.hoursPracticas,
    required this.isActive,
  });
}

class HojaFormularioCiclo extends StatefulWidget {
  final CicloModel? cycle;
  final List<CarreraModel> careers;
  final String? fixedCareerId;

  const HojaFormularioCiclo({
    super.key,
    this.cycle,
    required this.careers,
    this.fixedCareerId,
  });

  @override
  State<HojaFormularioCiclo> createState() => _HojaFormularioCicloState();
}

class _HojaFormularioCicloState extends State<HojaFormularioCiclo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _levelController;
  late final TextEditingController _hoursPracticasController;
  late String _selectedCareerId;
  late bool _isActive;

  CarreraModel? get _selectedCareer {
    for (final career in widget.careers) {
      if (career.id == _selectedCareerId) return career;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cycle?.name ?? '');
    _levelController = TextEditingController(
      text: widget.cycle?.level.toString() ?? '',
    );
    _hoursPracticasController = TextEditingController(
      text: widget.cycle?.hoursPracticas.toString() ?? '0',
    );
    _selectedCareerId =
        widget.fixedCareerId ??
        widget.cycle?.careerId ??
        (widget.careers.isNotEmpty ? widget.careers.first.id : '');
    _isActive = widget.cycle?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    _hoursPracticasController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      CicloFormResult(
        name: _nameController.text.trim(),
        careerId: _selectedCareerId,
        level: int.parse(_levelController.text.trim()),
        hoursPracticas: int.parse(_hoursPracticasController.text.trim()),
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
                  title: widget.cycle == null
                      ? 'Nuevo semestre'
                      : 'Editar semestre',
                  subtitle: 'Define el nivel y estado del semestre académico.',
                  icon: Icons.layers_outlined,
                ),
                const EtiquetaSeccionFormularioAdmin(
                  'Información del semestre',
                ),
                if (widget.fixedCareerId == null)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCareerId.isEmpty
                        ? null
                        : _selectedCareerId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Carrera'),
                    items: widget.careers
                        .map(
                          (career) => DropdownMenuItem<String>(
                            value: career.id,
                            child: Text(career.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCareerId = value ?? ''),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Selecciona una carrera'
                        : null,
                  )
                else
                  Text(
                    widget.careers.isNotEmpty
                        ? widget.careers.first.name
                        : 'Carrera seleccionada',
                    style: AppEstiloTexto.bodyBold.copyWith(
                      color: AppColores.textPrimary,
                    ),
                  ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _nameController,
                  etiqueta: 'Nombre del semestre',
                  icono: Icons.layers_outlined,
                  validador: (value) {
                    return ValidadoresAdmin.letters(
                      value,
                      label: 'El nombre del semestre',
                    );
                  },
                ),
                const EtiquetaSeccionFormularioAdmin('Estado'),
                CampoFormularioPrisma(
                  controlador: _levelController,
                  etiqueta: 'Nivel',
                  icono: Icons.format_list_numbered_rounded,
                  tipoTeclado: TextInputType.number,
                  textoAyuda: _selectedCareer == null
                      ? null
                      : 'Máximo permitido: ${_selectedCareer!.totalSemesters}',
                  validador: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Ingresa un nivel válido';
                    }
                    final maximum = _selectedCareer?.totalSemesters;
                    if (maximum != null && parsed > maximum) {
                      return 'El nivel no puede superar los $maximum semestres configurados.';
                    }
                    return null;
                  },
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _hoursPracticasController,
                  etiqueta: 'Horas requeridas de prácticas',
                  textoAyuda: 'Número total de horas de práctica del semestre',
                  icono: Icons.schedule_outlined,
                  tipoTeclado: TextInputType.number,
                  validador: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Ingresa un valor válido de horas';
                    }
                    return null;
                  },
                ),
                AppTamanos.gapV16,
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
                          _isActive ? 'Semestre activo' : 'Semestre inactivo',
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
                  texto: widget.cycle == null
                      ? 'Guardar semestre'
                      : 'Actualizar semestre',
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
}
