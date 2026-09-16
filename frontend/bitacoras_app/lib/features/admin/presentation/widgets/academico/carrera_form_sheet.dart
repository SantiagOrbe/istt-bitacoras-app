import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../admin_form_components.dart';

class CarreraFormSheet extends StatefulWidget {
  final List<CarreraModel> existingCareers;

  const CarreraFormSheet({super.key, this.existingCareers = const []});

  @override
  State<CarreraFormSheet> createState() => _CarreraFormSheetState();
}

class _CarreraFormSheetState extends State<CarreraFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _semestersController = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _shortNameController.dispose();
    _descriptionController.dispose();
    _semestersController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final career = CarreraModel(
      id: '',
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      shortName: _shortNameController.text.trim(),
      description: _descriptionController.text.trim(),
      modality: '',
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
                  title: 'Nueva carrera',
                  subtitle: 'Registra la información académica de la carrera.',
                  icon: Icons.school_outlined,
                ),
                const AdminFormSectionLabel('Información general'),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la carrera',
                  ),
                  validator: (value) {
                    return AdminValidators.letters(
                          value,
                          label: 'El nombre de la carrera',
                        ) ??
                        AdminValidators.unique(
                          value,
                          widget.existingCareers.map((career) => career.name),
                          label: 'La carrera',
                        );
                  },
                ),
                AppSizes.gapV12,
                TextFormField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Código de carrera',
                  ),
                  validator: (value) {
                    return AdminValidators.requiredText(
                          value,
                          label: 'El código de la carrera',
                        ) ??
                        AdminValidators.unique(
                          value,
                          widget.existingCareers.map((career) => career.code),
                          label: 'El código',
                        );
                  },
                ),
                AppSizes.gapV12,
                TextFormField(
                  controller: _shortNameController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Sigla'),
                  validator: (value) {
                    return AdminValidators.requiredText(
                          value,
                          label: 'La sigla',
                        ) ??
                        AdminValidators.unique(
                          value,
                          widget.existingCareers.map(
                            (career) => career.shortName,
                          ),
                          label: 'La sigla',
                        );
                  },
                ),
                AppSizes.gapV12,
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    return AdminValidators.requiredText(
                      value,
                      label: 'La descripción',
                    );
                  },
                ),
                const AdminFormSectionLabel('Configuración académica'),
                SwitchListTile.adaptive(
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                  title: const Text('Carrera activa'),
                  contentPadding: EdgeInsets.zero,
                ),
                AppSizes.gapV16,
                TextFormField(
                  controller: _semestersController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total de semestres',
                  ),
                  validator: (value) {
                    return AdminValidators.positiveInteger(
                      value,
                      label: 'El total de semestres',
                    );
                  },
                ),
                AppSizes.gapV20,
                AdminFormActionButton(
                  label: 'Guardar carrera',
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
