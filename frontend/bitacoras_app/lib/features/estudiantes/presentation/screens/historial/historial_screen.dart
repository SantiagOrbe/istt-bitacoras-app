import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import '../../controllers/historial_controller.dart';
import '../../widgets/historial/historial_body.dart';

class HistorialScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAsistenciaRepository attendanceRepository;
  final VoidCallback? onRegisterExit;

  const HistorialScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
    this.onRegisterExit,
  });

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late final HistorialController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistorialController(repository: widget.attendanceRepository);
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
          appBar: InicioAppBar(user: widget.currentUser),
          body: SafeArea(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : HistorialBody(
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
