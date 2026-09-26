import 'package:bitacoras_app/features/tutores/tutores.dart';


class ReportesTutorScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const ReportesTutorScreen({super.key, required this.currentUser});

  @override
  State<ReportesTutorScreen> createState() => _ReportesTutorScreenState();
}

class _ReportesTutorScreenState extends State<ReportesTutorScreen> {
  List<Map<String, dynamic>> _visits = const [];
  bool _isLoading = true;
  bool _isGenerating = false;

  String get _latestVisitDate {
    if (_visits.isEmpty) return 'Sin registros';
    for (final visit in _visits) {
      final date = visit['fecha']?.toString() ?? '';
      if (date.isNotEmpty) return date;
    }
    return 'Sin fecha';
  }

  int get _visitsWithActivity => _visits.where((visit) {
        final activity = visit['actividad_descripcion'] ?? visit['actividades'];
        return activity?.toString().trim().isNotEmpty == true;
      }).length;

  int get _completedVisits => _visits.where((visit) {
        final exit = visit['hora_salida'] ?? visit['salida'];
        return exit != null && exit.toString().isNotEmpty;
      }).length;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    try {
      final visits = await context.read<ITutorRepository>().getTutorVisitHistory();
      if (!mounted) return;
      setState(() {
        _visits = visits;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = await context.read<ITutorRepository>().downloadTutorReportPdf();
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/hoja_ruta_tutor_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await File(path).writeAsBytes(bytes);
      await OpenFile.open(path);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generación de PDF completa. Guardado en Descargas.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo generar el PDF.')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColores.primary))
          : RefreshIndicator(
              color: AppColores.primary,
              onRefresh: _loadVisits,
              child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTamanos.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InstitutionalGlowCard(
                    accentColor: AppColores.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTamanos.lg),
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined, size: 34, color: AppColores.primary),
                          AppTamanos.gapH12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reportes de visitas', style: AppEstiloTexto.heading),
                                AppTamanos.gapV4,
                                Text(
                                  'Genera la hoja de ruta institucional con tus registros.',
                                  style: AppEstiloTexto.body.copyWith(color: AppColores.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppTamanos.gapV12,
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 620 ? 3 : 2;
                      final width = (constraints.maxWidth - AppTamanos.sm * (columns - 1)) / columns;
                      return Wrap(
                        spacing: AppTamanos.sm,
                        runSpacing: AppTamanos.sm,
                        children: [
                          _ReportMetricCard(
                            width: width,
                            icon: Icons.assignment_outlined,
                            label: 'Visitas',
                            value: '${_visits.length}',
                            color: AppColores.secondary,
                          ),
                          _ReportMetricCard(
                            width: width,
                            icon: Icons.event_available_outlined,
                            label: 'Finalizadas',
                            value: '$_completedVisits',
                            color: AppColores.success,
                          ),
                          _ReportMetricCard(
                            width: width,
                            icon: Icons.edit_note_outlined,
                            label: 'Con actividad',
                            value: '$_visitsWithActivity',
                            color: AppColores.info,
                          ),
                          _ReportMetricCard(
                            width: width,
                            icon: Icons.calendar_today_outlined,
                            label: 'Última visita',
                            value: _latestVisitDate,
                            color: AppColores.primary,
                          ),
                        ],
                      );
                    },
                  ),
                  AppTamanos.gapV16,
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isGenerating ? null : _generateReport,
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(_isGenerating ? 'Generando...' : 'Generar reporte PDF'),
                    ),
                  ),
                ],
              ),
              ),
            ),
    );
  }
}

class _ReportMetricCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ReportMetricCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InstitutionalGlowCard(
        accentColor: color,
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
          child: Row(
            children: [
              Icon(icon, color: color, size: 26),
              AppTamanos.gapH8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppEstiloTexto.caption),
                    AppTamanos.gapV4,
                    Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppEstiloTexto.bodyBold),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
