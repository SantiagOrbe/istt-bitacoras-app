// lib/features/estudiantes/presentation/screens/asistencia/registro_salida_screen.dart
import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:bitacoras_app/features/estudiantes/presentation/widgets/asistencia/registro_asistencia_body.dart';

class RegistroSalidaScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAsistenciaRepository attendanceRepository;

  const RegistroSalidaScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
  });

  @override
  State<RegistroSalidaScreen> createState() => _RegistroSalidaScreenState();
}

class _RegistroSalidaScreenState extends State<RegistroSalidaScreen> {
  late final RegistroSalidaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegistroSalidaController(
      repository: widget.attendanceRepository,
    );
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmExit() async {
    final success = await _controller.confirmExit();
    if (success && mounted) {
      context.go('/register-activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final companyName =
            _controller.company?.name ?? widget.currentUser.company;
        final date = _controller.currentRecord?.date ?? '24/10/2026';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(user: widget.currentUser),
          body: _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cuerpo reutilizado parametrizado para Salida
                        RegistroAsistenciaBody(
                          title: 'Registrar Salida',
                          currentTime: '05:00 PM',
                          currentDate: date,
                          companyName: companyName ?? "Sin Empresa Asignada",
                        ),
                        AppSizes.gapV24,

                        // Botones reutilizados parametrizados para Salida
                        AsistenciaActionButtons(
                          isEntry: false,
                          isLoading: _controller.isSaving,
                          onConfirm: _handleConfirmExit,
                          onCancel: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
