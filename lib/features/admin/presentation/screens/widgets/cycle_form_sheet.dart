import 'package:bitacoras_app/features/admin/domain/models/cycle_model.dart';
import 'package:bitacoras_app/shared/exports.dart';

class CycleFormResult {
  final String name;
  final int level;
  final bool isActive;

  const CycleFormResult({
    required this.name,
    required this.level,
    required this.isActive,
  });
}

class CycleFormSheet extends StatefulWidget {
  final CycleModel? cycle;

  const CycleFormSheet({
    super.key,
    this.cycle,
  });

  @override
  State<CycleFormSheet> createState() => _CycleFormSheetState();
}

class _CycleFormSheetState extends State<CycleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _levelController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cycle?.name ?? '');
    _levelController = TextEditingController(text: widget.cycle?.level.toString() ?? '');
    _isActive = widget.cycle?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      CycleFormResult(
        name: _nameController.text.trim(),
        level: int.parse(_levelController.text.trim()),
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
                  widget.cycle == null ? 'Nuevo curso' : 'Editar curso',
                  style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary),
                ),
                AppSizes.gapV20,
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del curso',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el nombre del curso';
                    }
                    return null;
                  },
                ),
                AppSizes.gapV16,
                TextFormField(
                  controller: _levelController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nivel',
                  ),
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Ingresa un nivel válido';
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
                  title: const Text('Curso activo'),
                  contentPadding: EdgeInsets.zero,
                ),
                AppSizes.gapV24,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(widget.cycle == null ? 'Guardar curso' : 'Actualizar curso'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
