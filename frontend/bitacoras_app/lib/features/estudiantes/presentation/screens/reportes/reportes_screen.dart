import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class ReportesScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAsistenciaRepositorio attendanceRepository;

  const ReportesScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
  });

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  late final ReportesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ReportesController(
      repository: widget.attendanceRepository,
      currentUser: widget.currentUser,
    );
    _controller.loadReportData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleGeneratePdf() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Generando archivo PDF de bitácora...',
          style: AppEstiloTexto.body.copyWith(color: AppColores.surface),
        ),
        backgroundColor: AppColores.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    final statusMessage = await _controller.generatePdfReport();

    if (!mounted) return;

    final isSuccess = statusMessage == 'Generacion de pdf completa';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          statusMessage,
          style: AppEstiloTexto.body.copyWith(color: AppColores.surface),
        ),
        backgroundColor: isSuccess ? AppColores.success : AppColores.error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColores.background,
          appBar: InicioAppBar(user: widget.currentUser),
          body: SafeArea(
            child: ReportesBody(
              period: _controller.period,
              completedHours: _controller.completedHours,
              totalHours: _controller.totalHours,
              onGeneratePdf: _handleGeneratePdf,
            ),
          ),
        );
      },
    );
  }
}
