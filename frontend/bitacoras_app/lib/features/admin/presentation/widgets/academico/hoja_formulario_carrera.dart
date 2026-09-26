import 'package:bitacoras_app/features/admin/admin.dart';

class HojaFormularioCarrera extends StatefulWidget {
  final List<CarreraModel> existingCareers;
  final CarreraModel? career;

  const HojaFormularioCarrera({
    super.key,
    this.existingCareers = const [],
    this.career,
  });

  @override
  State<HojaFormularioCarrera> createState() => _HojaFormularioCarreraState();
}

class _HojaFormularioCarreraState extends State<HojaFormularioCarrera> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _shortNameController;
  late final TextEditingController _modalityController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _semestersController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final career = widget.career;
    _nameController = TextEditingController(text: career?.name ?? '');
    _codeController = TextEditingController(text: career?.code ?? '');
    _shortNameController = TextEditingController(text: career?.shortName ?? '');
    _descriptionController = TextEditingController(
      text: career?.description ?? '',
    );
    _semestersController = TextEditingController(
      text: career?.totalSemesters.toString() ?? '',
    );
    _modalityController = TextEditingController(text: career?.modality ?? '');
    _isActive = career?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _shortNameController.dispose();
    _modalityController.dispose();
    _descriptionController.dispose();
    _semestersController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final career = CarreraModel(
      id: widget.career?.id ?? '',
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      shortName: _shortNameController.text.trim(),
      description: _descriptionController.text.trim(),
      modality: _modalityController.text.trim(),
      isActive: _isActive,
      totalSemesters: int.parse(_semestersController.text.trim()),
    );

    Navigator.of(context).pop(career);
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
                  title: widget.career == null
                      ? 'Nueva carrera'
                      : 'Editar carrera',
                  subtitle: widget.career == null
                      ? 'Registra la información académica de la carrera.'
                      : 'Actualiza la información académica de la carrera.',
                  icon: Icons.school_outlined,
                ),
                const EtiquetaSeccionFormularioAdmin('Información general'),
                CampoFormularioPrisma(
                  controlador: _nameController,
                  etiqueta: 'Nombre de la carrera',
                  icono: Icons.school_outlined,
                  capitalizacion: TextCapitalization.words,
                  validador: (value) {
                    return ValidadoresAdmin.lettersWithAccents(
                          value,
                          label: 'El nombre de la carrera',
                        ) ??
                        ValidadoresAdmin.unique(
                          value,
                          widget.existingCareers
                              .where((career) => career.id != widget.career?.id)
                              .map((career) => career.name),
                          label: 'La carrera',
                        );
                  },
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _codeController,
                  etiqueta: 'Código de carrera',
                  icono: Icons.qr_code_2_outlined,
                  capitalizacion: TextCapitalization.characters,
                  validador: (value) {
                    return ValidadoresAdmin.careerCode(
                          value,
                          label: 'El código de la carrera',
                        ) ??
                        ValidadoresAdmin.unique(
                          value,
                          widget.existingCareers
                              .where((career) => career.id != widget.career?.id)
                              .map((career) => career.code),
                          label: 'El código',
                        );
                  },
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _shortNameController,
                  etiqueta: 'Sigla',
                  icono: Icons.short_text_rounded,
                  capitalizacion: TextCapitalization.characters,
                  validador: (value) {
                    return ValidadoresAdmin.requiredText(
                          value,
                          label: 'La sigla',
                        ) ??
                        ValidadoresAdmin.unique(
                          value,
                          widget.existingCareers
                              .where((career) => career.id != widget.career?.id)
                              .map((career) => career.shortName),
                          label: 'La sigla',
                        );
                  },
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _descriptionController,
                  etiqueta: 'Descripción',
                  icono: Icons.description_outlined,
                  maxLineas: 3,
                  validador: (value) {
                    return ValidadoresAdmin.lettersWithAccents(
                      value,
                      label: 'La descripción',
                    );
                  },
                ),
                AppTamanos.gapV12,
                CampoFormularioPrisma(
                  controlador: _modalityController,
                  etiqueta: 'Modalidad',
                  textoSugerido: 'Ej: Presencial',
                  icono: Icons.location_city_outlined,
                  capitalizacion: TextCapitalization.words,
                  validador: (value) =>
                      ValidadoresAdmin.letters(value, label: 'La modalidad'),
                ),
                const EtiquetaSeccionFormularioAdmin('Configuración académica'),
                AppTamanos.gapV16,
                CampoFormularioPrisma(
                  controlador: _semestersController,
                  etiqueta: 'Total de semestres',
                  icono: Icons.format_list_numbered_rounded,
                  tipoTeclado: TextInputType.number,
                  validador: (value) {
                    return ValidadoresAdmin.positiveInteger(
                      value,
                      label: 'El total de semestres',
                    );
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
                          _isActive ? 'Carrera activa' : 'Carrera inactiva',
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
                  texto: widget.career == null
                      ? 'Guardar carrera'
                      : 'Actualizar carrera',
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
