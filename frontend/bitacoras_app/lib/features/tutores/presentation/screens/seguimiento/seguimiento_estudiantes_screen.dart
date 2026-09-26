import 'package:bitacoras_app/features/tutores/tutores.dart';

class SeguimientoEstudiantesScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final bool isAcademic;

  const SeguimientoEstudiantesScreen({
    super.key,
    required this.currentUser,
    required this.isAcademic,
  });

  @override
  State<SeguimientoEstudiantesScreen> createState() =>
      _SeguimientoEstudiantesScreenState();
}

class _SeguimientoEstudiantesScreenState extends State<SeguimientoEstudiantesScreen> with SingleTickerProviderStateMixin {
  final List<EstudianteAsignadoModel> _asignados = [];
  final List<RegistroPracticaModel> _listaRegistros = [];
  bool _loading = true;
  late final TabController _tabController;

  @override void initState() { super.initState(); _tabController = TabController(length: 2, vsync: this); _cargarDatos(); }
  @override void dispose() { _tabController.dispose(); super.dispose(); }

  Future<void> _cargarDatos() async {
    try {
      final repo = context.read<ITutorRepository>();
      final data = await repo.getAssignedStudents(widget.currentUser.id, isAcademic: widget.isAcademic);
      final registros = <RegistroPracticaModel>[];
      for (final item in data) { registros.addAll(await repo.getStudentLogs(item.student.id, isAcademic: widget.isAcademic)); }
      if (!mounted) return;
      setState(() { _asignados..clear()..addAll(data); _listaRegistros..clear()..addAll(registros); _loading = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _asignados.clear(); _listaRegistros.clear(); _loading = false; });
    }
  }

  Future<void> _toggleRegistro(RegistroPracticaModel log) async {
    try {
      final updated = await context.read<ITutorRepository>().updateLog(logId: log.id, isActive: !log.isActive);
      if (!mounted) return;
      setState(() { final index = _listaRegistros.indexWhere((item) => item.id == log.id); if (index != -1) _listaRegistros[index] = updated; });
    } catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo cambiar el estado del registro.'))); }
  }

  Future<void> _editarRegistro(RegistroPracticaModel log) async {
    final controller = TextEditingController(text: log.activityDescription);
    final result = await showDialog<String>(context: context, builder: (_) => AlertDialog(title: const Text('Editar registro'), content: TextField(controller: controller, maxLines: 4, decoration: const InputDecoration(hintText: 'Describe la actividad realizada', border: OutlineInputBorder())), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Guardar'))]));
    controller.dispose();
    if (result == null || result.isEmpty || !mounted) return;
    try {
      final updated = await context.read<ITutorRepository>().updateLog(logId: log.id, activityDescription: result);
      if (!mounted) return;
      setState(() { final index = _listaRegistros.indexWhere((item) => item.id == log.id); if (index != -1) _listaRegistros[index] = updated; });
    } catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo guardar el registro.'))); }
  }

  Widget _tutoriados() => ListaTutoriadosSeguimiento(isLoading: _loading, items: _asignados, onOpen: (item) => Navigator.push(context, MaterialPageRoute(builder: (_) => DetalleSeguimientoEstudianteScreen(assignedStudent: item))));
  Widget _registros() => _loading ? const Center(child: CircularProgressIndicator(color: AppColores.primary)) : _listaRegistros.isEmpty ? Center(child: Text('No hay registros de práctica para mostrar.', style: AppEstiloTexto.body)) : ListView.builder(padding: const EdgeInsets.all(8), itemCount: _listaRegistros.length, itemBuilder: (_, i) => RegistroSeguimientoCard(log: _listaRegistros[i], onEdit: () => _editarRegistro(_listaRegistros[i]), onToggle: () => _toggleRegistro(_listaRegistros[i])));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            EncabezadoSeguimientoEstudiantes(currentUser: widget.currentUser),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColores.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColores.outline),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColores.primary,
                labelColor: AppColores.primary,
                unselectedLabelColor: AppColores.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [Tab(text: 'Tutoriados'), Tab(text: 'Registros')],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: TabBarView(controller: _tabController, children: [_tutoriados(), _registros()])),
          ],
        ),
      ),
    );
  }
}