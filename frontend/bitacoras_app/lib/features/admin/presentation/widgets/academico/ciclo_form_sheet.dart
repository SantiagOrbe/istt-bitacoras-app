import 'package:bitacoras_app/features/admin/domain/models/ciclo_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../admin_form_components.dart';

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

class CicloFormSheet extends StatefulWidget {
  final CicloModel? cycle;
  final List<CarreraModel> careers;
  final String? fixedCareerId;

  const CicloFormSheet({
    super.key,
    this.cycle,
    required this.careers,
    this.fixedCareerId,
  });

  @override
  State<CicloFormSheet> createState() => _CicloFormSheetState();
}

class _CicloFormSheetState extends State<CicloFormSheet> {
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
                  title: widget.cycle == null
                      ? 'Nuevo semestre'
                      : 'Editar semestre',
                  subtitle: 'Define el nivel y estado del semestre académico.',
                  icon: Icons.layers_outlined,
                ),
                const AdminFormSectionLabel('Información del semestre'),
                if (widget.fixedCareerId == null)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCareerId.isEmpty
                        ? null
                        : _selectedCareerId,
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
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                AppSizes.gapV12,
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del semestre',
                  ),
                  validator: (value) {
                    return AdminValidators.letters(
                      value,
                      label: 'El nombre del semestre',
                    );
                  },
                ),
                const AdminFormSectionLabel('Estado'),
                TextFormField(
                  controller: _levelController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nivel',
                    helperText: _selectedCareer == null
                        ? null
                        : 'Máximo permitido: ${_selectedCareer!.totalSemesters}',
                    errorMaxLines: 2,
                  ),
                  validator: (value) {
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
                AppSizes.gapV12,
                TextFormField(
                  controller: _hoursPracticasController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Horas requeridas de prácticas',
                    helperText: 'Número total de horas de práctica del semestre',
                  ),
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Ingresa un valor válido de horas';
                    }
                    return null;
                  },
                ),
                AppSizes.gapV16,
                SwitchListTile.adaptive(
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                  title: const Text('Semestre activo'),
                  contentPadding: EdgeInsets.zero,
                ),
                AppSizes.gapV20,
                AdminFormActionButton(
                  label: widget.cycle == null
                      ? 'Guardar semestre'
                      : 'Actualizar semestre',
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
