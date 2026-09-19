import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class AvancePracticasScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAsistenciaRepository attendanceRepository;
  final VoidCallback? onRegisterExit;

  const AvancePracticasScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
    this.onRegisterExit,
  });

  @override
  State<AvancePracticasScreen> createState() => _AvancePracticasScreenState();
}

typedef HistorialScreen = AvancePracticasScreen;

class _AvancePracticasScreenState extends State<AvancePracticasScreen> {
  late final HistorialController _controller;
  Map<String, dynamic> _practiceProgress = {
    'horas_acumuladas': 0.0,
    'horas_requeridas': 0,
    'porcentaje': 0.0,
    'completo': false,
  };
  bool _isProgressLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = HistorialController(repository: widget.attendanceRepository);
    _controller.fetchHistory();
    _loadPracticeProgress();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPracticeProgress() async {
    try {
      final progress = await widget.attendanceRepository.getStudentPracticeProgress();
      if (!mounted) return;
      setState(() {
        _practiceProgress = progress;
        _isProgressLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _practiceProgress = {
          'horas_acumuladas': 0.0,
          'horas_requeridas': 0,
          'porcentaje': 0.0,
          'completo': false,
        };
        _isProgressLoading = false;
      });
    }
  }

  double _calculateCompletedHours() {
    final totalMinutes = _controller.historyList.fold<int>(0, (sum, record) {
      if (record.exitTime == null || record.entryTime.isEmpty) return sum;
      final entry = _parseTime(record.entryTime);
      final exit = _parseTime(record.exitTime!);
      if (entry == null || exit == null) return sum;
      final deltaMinutes = exit.difference(entry).inMinutes;
      return sum + (deltaMinutes > 0 ? deltaMinutes : 0);
    });
    return totalMinutes / 60;
  }

  DateTime? _parseTime(String timeText) {
    if (timeText.trim().isEmpty) return null;
    final normalized = timeText.trim();
    final parts = normalized.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    final derivedCompletedHours = (_practiceProgress['horas_acumuladas'] is num)
        ? (_practiceProgress['horas_acumuladas'] as num).toDouble()
        : _calculateCompletedHours();
    final derivedTotalHours = (_practiceProgress['horas_requeridas'] is num)
        ? (_practiceProgress['horas_requeridas'] as num).toDouble()
        : (widget.currentUser.horasPracticas > 0
            ? widget.currentUser.horasPracticas.toDouble()
            : 0.0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(user: widget.currentUser),
          body: SafeArea(
            child: _controller.isLoading || _isProgressLoading
                ? const Center(child: CircularProgressIndicator())
                : HistorialBody(
                    activeRecord: _controller.activeRecord,
                    historyList: _controller.historyList,
                    onRegisterExit: widget.onRegisterExit,
                    semesterName: widget.currentUser.semestreNombre ?? 'Semestre actual',
                    totalRequiredHours: derivedTotalHours,
                    completedHours: derivedCompletedHours,
                  ),
          ),
        );
      },
    );
  }
}
