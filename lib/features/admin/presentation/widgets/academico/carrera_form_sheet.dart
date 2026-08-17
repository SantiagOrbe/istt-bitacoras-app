import 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
import 'package:bitacoras_app/shared/exports.dart';

class CarreraFormSheet extends StatefulWidget {
  const CarreraFormSheet({super.key});

  @override
  State<CarreraFormSheet> createState() => _CarreraFormSheetState();
}

class _CarreraFormSheetState extends State<CarreraFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _modalityController = TextEditingController();
  final _semestersController = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _shortNameController.dispose();
    _descriptionController.dispose();
    _modalityController.dispose();
    _semestersController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final career = CarreraModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
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
                'Nueva carrera',
                style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary),
              ),
              AppSizes.gapV20,
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la carrera',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre de la carrera';
                  }
                  return null;
                },
              ),
              AppSizes.gapV16,
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Código de carrera',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el código de la carrera';
                  }
                  return null;
                },
              ),
              AppSizes.gapV16,
              TextFormField(
                controller: _shortNameController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Sigla',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la sigla de la carrera';
                  }
                  return null;
                },
              ),
              AppSizes.gapV16,
              TextFormField(
                controller: _modalityController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Modalidad',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la modalidad';
                  }
                  return null;
                },
              ),
              AppSizes.gapV16,
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa una descripción';
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
                  final number = int.tryParse(value ?? '');
                  if (number == null || number <= 0) {
                    return 'Ingresa un número válido mayor a cero';
                  }
                  return null;
                },
              ),
              AppSizes.gapV24,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Guardar carrera'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
