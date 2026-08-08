import 'package:bitacoras_app/features/estudiantes/attendance.dart';
import '../controllers/reports_controller.dart';
import '../widgets/reports/reports_body.dart';

class ReportsScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAttendanceRepository attendanceRepository;

  const ReportsScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late final ReportsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ReportsController(repository: widget.attendanceRepository);
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
          appBar: HomeAppBar(user: widget.currentUser),
          body: SafeArea(
            child: ReportsBody(
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