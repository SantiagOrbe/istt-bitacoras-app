import 'package:bitacoras_app/features/admin/domain/models/cycle_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/parallel_model.dart';
import 'package:bitacoras_app/shared/exports.dart';

class ParallelFormResult {
  final String cycleId;
  final String name;
  final String jornada;
  final bool isActive;

  const ParallelFormResult({
    required this.cycleId,
    required this.name,
    required this.jornada,
    required this.isActive,
  });
}

class ParallelFormSheet extends StatefulWidget {
  final List<CycleModel> cycles;
  final ParallelModel? parallel;

  const ParallelFormSheet({
    super.key,
    required this.cycles,
    this.parallel,
  });

  @override
  State<ParallelFormSheet> createState() => _ParallelFormSheetState();
}

class _ParallelFormSheetState extends State<ParallelFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedCycleId;
  late String _selectedJornada;
  late bool _isActive;

  static const List<String> _jornadas = ['Matutina', 'Vespertina', 'Nocturna'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.parallel?.name ?? '');
    _selectedCycleId = widget.parallel?.cycleId ?? (widget.cycles.isNotEmpty ? widget.cycles.first.id : '');
    _selectedJornada = widget.parallel?.jornada ?? _jornadas.first;
    _isActive = widget.parallel?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      ParallelFormResult(
        cycleId: _selectedCycleId,
        name: _nameController.text.trim(),
        jornada: _selectedJornada,
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
                  widget.parallel == null ? 'Nuevo paralelo' : 'Editar paralelo',
                  style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary),
                ),
                AppSizes.gapV20,
                DropdownButtonFormField<String>(
                  value: _selectedCycleId.isEmpty ? null : _selectedCycleId,
                  decoration: const InputDecoration(labelText: 'Curso'),
                  items: widget.cycles
                      .map(
                        (cycle) => DropdownMenuItem<String>(
                          value: cycle.id,
                          child: Text('${cycle.name} (Nivel ${cycle.level})'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedCycleId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona un curso';
                    }
                    return null;
                  },
                ),
                AppSizes.gapV16,
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del paralelo',
                    hintText: 'A, B, C...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el nombre del paralelo';
                    }
                    return null;
                  },
                ),
                AppSizes.gapV16,
                DropdownButtonFormField<String>(
                  value: _selectedJornada,
                  decoration: const InputDecoration(labelText: 'Jornada'),
                  items: _jornadas
                      .map(
                        (jornada) => DropdownMenuItem<String>(
                          value: jornada,
                          child: Text(jornada),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedJornada = value;
                    });
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
                  title: const Text('Paralelo activo'),
                  contentPadding: EdgeInsets.zero,
                ),
                AppSizes.gapV24,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(widget.parallel == null ? 'Guardar paralelo' : 'Actualizar paralelo'),
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
