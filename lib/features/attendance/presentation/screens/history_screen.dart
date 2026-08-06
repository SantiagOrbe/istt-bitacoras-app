import 'package:bitacoras_app/features/attendance/attendance.dart';
import '../controllers/history_controller.dart';
import '../widgets/history_body.dart';

class HistoryScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAttendanceRepository attendanceRepository;
  final VoidCallback? onRegisterExit;

  const HistoryScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
    this.onRegisterExit,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistoryController(repository: widget.attendanceRepository);
    _controller.fetchHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : HistoryBody(
                    activeRecord: _controller.activeRecord,
                    historyList: _controller.historyList,
                    onRegisterExit: widget.onRegisterExit,
                  ),
          ),
        );
      },
    );
  }
}