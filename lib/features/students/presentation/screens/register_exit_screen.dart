// lib/features/attendance/presentation/screens/register_exit_screen.dart
import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/students/attendance.dart';
import 'package:bitacoras_app/features/students/presentation/widgets/register_attendance_body.dart';

class RegisterExitScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAttendanceRepository attendanceRepository;

  const RegisterExitScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
  });

  @override
  State<RegisterExitScreen> createState() => _RegisterExitScreenState();
}

class _RegisterExitScreenState extends State<RegisterExitScreen> {
  late final RegisterExitController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterExitController(repository: widget.attendanceRepository);
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
        final companyName = _controller.company?.name ?? widget.currentUser.company;
        final date = _controller.currentRecord?.date ?? '24/10/2026';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(user: widget.currentUser),
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
                        RegisterAttendanceBody(
                          title: 'Registrar Salida',
                          currentTime: '05:00 PM',
                          currentDate: date,
                          companyName: companyName ?? "Sin Empresa Asignada",
                        ),
                        AppSizes.gapV24,

                        // Botones reutilizados parametrizados para Salida
                        AttendanceActionButtons(
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