import 'package:bitacoras_app/features/admin/domain/models/ciclo_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/paralelo_model.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../admin_form_components.dart';

class ParaleloFormResult {
  final String cycleId;
  final String name;
  final String jornada;
  final bool isActive;

  const ParaleloFormResult({
    required this.cycleId,
    required this.name,
    required this.jornada,
    required this.isActive,
  });
}

class ParaleloFormSheet extends StatefulWidget {
  final List<CicloModel> cycles;
  final ParaleloModel? parallel;
  final String? fixedCycleId;

  const ParaleloFormSheet({
    super.key,
    required this.cycles,
    this.parallel,
    this.fixedCycleId,
  });

  @override
  State<ParaleloFormSheet> createState() => _ParaleloFormSheetState();
}

class _ParaleloFormSheetState extends State<ParaleloFormSheet> {
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
    _selectedCycleId =
        widget.fixedCycleId ??
        widget.parallel?.cycleId ??
        (widget.cycles.isNotEmpty ? widget.cycles.first.id : '');
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
      ParaleloFormResult(
        cycleId: _selectedCycleId,
        name: _nameController.text.trim(),
        jornada: _selectedJornada,
        isActive: _isActive,
      ),
    );
  }

  String get _selectedSemesterName {
    for (final cycle in widget.cycles) {
      if (cycle.id == _selectedCycleId) return cycle.name;
    }
    return 'Semestre seleccionado';
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
                  title: widget.parallel == null
                      ? 'Nuevo paralelo'
                      : 'Editar paralelo',
                  subtitle: 'Asocia una jornada y un semestre al paralelo.',
                  icon: Icons.grid_view_outlined,
                ),
                const AdminFormSectionLabel('Asignación académica'),
                if (widget.fixedCycleId == null)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCycleId.isEmpty
                        ? null
                        : _selectedCycleId,
                    decoration: const InputDecoration(labelText: 'Semestre'),
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'Selecciona un semestre'
                        : null,
                  )
                else
                  Text(
                    'Semestre: $_selectedSemesterName',
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                AppSizes.gapV12,
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del paralelo',
                    hintText: 'A, B, C...',
                  ),
                  validator: (value) {
                    return AdminValidators.letters(
                      value,
                      label: 'El nombre del paralelo',
                    );
                  },
                ),
                AppSizes.gapV12,
                DropdownButtonFormField<String>(
                  initialValue: _selectedJornada,
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
                const AdminFormSectionLabel('Estado'),
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
                AppSizes.gapV20,
                AdminFormActionButton(
                  label: widget.parallel == null
                      ? 'Guardar paralelo'
                      : 'Actualizar paralelo',
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
