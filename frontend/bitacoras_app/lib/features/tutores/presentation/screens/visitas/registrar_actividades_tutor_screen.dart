import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
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
  bool _isLoading = true, _isSaving = false;

  @override void initState() { super.initState(); _loadVisit(); }
  @override void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadVisit() async {
    try {
      final visit = await context.read<ITutorRepository>().getTodayVisitStatus();
      if (!mounted) return;
      setState(() {
        _visit = visit;
        final actividades = visit.actividades.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        for (final c in _controllers) {
          c.dispose();
        }
        _controllers..clear()..addAll(actividades.isEmpty ? [TextEditingController()] : actividades.map((a) => TextEditingController(text: a)));
        _isLoading = false;
      });
    } catch (_) { if (mounted) setState(() => _isLoading = false); }
  }

  Future<void> _save() async {
    final visit = _visit;
    final text = _controllers.map((c) => c.text.trim()).where((e) => e.isNotEmpty).join('\n');
    if (visit?.id == null || text.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final updated = await context.read<ITutorRepository>().updateTutorActivities(visitId: visit!.id!, activities: text);
      if (!mounted) return;
      setState(() => _visit = updated);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Actividades guardadas correctamente.')));
      context.go(AppRoutes.registrarSalidaTutor);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudieron guardar las actividades.')));
    } finally { if (mounted) setState(() => _isSaving = false); }
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = _visit?.puedeRegistrarActividades ?? false;
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: AppColores.primary)) : SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RegistroActividadHeader(),
              const SizedBox(height: 24),
              Text(_visit?.empresaNombre.isNotEmpty == true ? 'Visita en ${_visit!.empresaNombre}' : 'No hay una visita activa para hoy.', style: const TextStyle(color: AppColores.textSecondary)),
              const SizedBox(height: 16),
              ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _controllers.length, separatorBuilder: (_, index) => const SizedBox(height: 16), itemBuilder: (_, i) => ActividadInputCard(index: i, controller: _controllers[i], canRemove: _controllers.length > 1, onRemove: () => setState(() { _controllers[i].dispose(); _controllers.removeAt(i); }))),
              const SizedBox(height: 16),
              CustomButton(isFullWidth: true, text: _isSaving ? 'Guardando...' : 'Guardar Actividad', icon: Icons.save_rounded, isLoading: _isSaving, onPressed: canEdit && !_isSaving ? _save : null),
              const SizedBox(height: 16),
              Center(child: TextButton.icon(onPressed: canEdit && !_isSaving ? () => setState(() => _controllers.add(TextEditingController())) : null, icon: const Icon(Icons.add_circle_outline_rounded), label: const Text('Agregar otra actividad'))),
            ],
          ),
        ),
      ),
    );
  }
}
