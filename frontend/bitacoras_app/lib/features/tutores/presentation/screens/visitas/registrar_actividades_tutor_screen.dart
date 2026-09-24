import 'package:bitacoras_app/features/tutores/tutores.dart';

class RegistrarActividadesTutorScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const RegistrarActividadesTutorScreen({super.key, required this.currentUser});

  @override
  State<RegistrarActividadesTutorScreen> createState() => _RegistrarActividadesTutorScreenState();
}

class _RegistrarActividadesTutorScreenState extends State<RegistrarActividadesTutorScreen> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  EstadoVisitaTutorModel? _visit;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadVisit();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadVisit() async {
    try {
      final visit = await context.read<ITutorRepository>().getTodayVisitStatus();
      if (!mounted) return;
      setState(() {
        _visit = visit;
        final savedActivities = visit.actividades
            .split('\n')
            .map((activity) => activity.trim())
            .where((activity) => activity.isNotEmpty)
            .toList();
        for (final controller in _controllers) {
          controller.dispose();
        }
        _controllers
          ..clear()
          ..addAll(savedActivities.isEmpty
              ? [TextEditingController()]
              : savedActivities.map(
                  (activity) => TextEditingController(text: activity),
                ));
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    final visit = _visit;
    final text = _controllers
      .map((controller) => controller.text.trim())
      .where((activity) => activity.isNotEmpty)
      .join('\n');
    if (visit?.id == null || text.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final updated = await context.read<ITutorRepository>().updateTutorActivities(
        visitId: visit!.id!,
        activities: text,
      );
      if (!mounted) return;
      setState(() => _visit = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividades guardadas correctamente.')),
      );
      context.go(AppRoutes.academicTutorRegisterDeparture);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron guardar las actividades.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = _visit?.puedeRegistrarActividades ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const RegistroActividadHeader(),
                  const SizedBox(height: 24),
                  Text(
                    _visit?.empresaNombre.isNotEmpty == true
                        ? 'Visita en ${_visit!.empresaNombre}'
                        : 'No hay una visita activa para hoy.',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _controllers.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => ActividadInputCard(
                      index: index,
                      controller: _controllers[index],
                      canRemove: _controllers.length > 1,
                      onRemove: () {
                        setState(() {
                          _controllers[index].dispose();
                          _controllers.removeAt(index);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    isFullWidth: true,
                    text: _isSaving ? 'Guardando...' : 'Guardar Actividad',
                    icon: Icons.save_rounded,
                    isLoading: _isSaving,
                    onPressed: canEdit && !_isSaving ? _save : null,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      onPressed: canEdit && !_isSaving
                          ? () => setState(() => _controllers.add(TextEditingController()))
                          : null,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: const Text('Agregar otra actividad'),
                    ),
                  ),
                  ],
                ),
              ),
            ),
    );
  }
}
