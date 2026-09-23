import 'dart:io';

import 'package:bitacoras_app/app/apps.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ReportesTutorScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const ReportesTutorScreen({super.key, required this.currentUser});

  @override
  State<ReportesTutorScreen> createState() => _ReportesTutorScreenState();
}

class _ReportesTutorScreenState extends State<ReportesTutorScreen> {
  final FakeTutorRepository _repository = FakeTutorRepository();
  List<Map<String, dynamic>> _visits = const [];
  bool _isLoading = true;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    try {
      final visits = await _repository.getTutorVisitHistory();
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
      final bytes = await _repository.downloadTutorReportPdf();
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
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Generar reportes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  const Text('Genera la hoja de ruta institucional con tus registros de visitas.', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          const Icon(Icons.assignment_outlined, size: 38, color: AppColors.primary),
                          const SizedBox(width: 14),
                          Expanded(child: Text('${_visits.length} visita(s) registrada(s)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
    );
  }
}
