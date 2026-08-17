import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import '../../controllers/reportes_controller.dart';
import '../../widgets/reportes/reportes_body.dart';

class ReportesScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAsistenciaRepository attendanceRepository;

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
    _controller = ReportesController(repository: widget.attendanceRepository);
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
          style: AppTextStyles.body.copyWith(color: AppColors.surface),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await _controller.generatePdfReport();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
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
