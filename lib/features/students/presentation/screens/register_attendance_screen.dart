import 'package:bitacoras_app/features/students/attendance.dart';
import 'package:bitacoras_app/features/students/presentation/widgets/register_attendance_body.dart';

class RegisterAttendanceScreen extends StatefulWidget {
  final bool isEntry;
  final String? timeLabel;
  final String? dateLabel;
  final UserModel currentUser;
  final IAttendanceRepository attendanceRepository;

  const RegisterAttendanceScreen({
    super.key,
    this.isEntry = true,
    this.timeLabel,
    this.dateLabel,
    required this.currentUser,
    required this.attendanceRepository,
  });

  @override
  State<RegisterAttendanceScreen> createState() => _RegisterAttendanceScreenState();
}

class _RegisterAttendanceScreenState extends State<RegisterAttendanceScreen> {
  late final RegisterAttendanceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterAttendanceController(repository: widget.attendanceRepository);
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final success = await _controller.confirmAttendance(
      isEntry: widget.isEntry,
      latitude: _controller.companyLocation?.latitude ?? -0.9938,
      longitude: _controller.companyLocation?.longitude ?? -77.8128,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEntry ? '¡Entrada registrada con éxito!' : '¡Salida registrada con éxito!',
            style: AppTextStyles.body.copyWith(color: AppColors.surface),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (widget.isEntry) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterActivityScreen(
            currentUser: widget.currentUser,
            attendanceRepository: widget.attendanceRepository,
          )),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEntry ? 'Registrar Entrada' : 'Registrar Salida';
    final currentTime = widget.timeLabel ?? (widget.isEntry ? '08:00 AM' : '17:00 PM');
    final currentDate = widget.dateLabel ?? '05/08/2026';

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final companyName = _controller.companyLocation?.name ?? 'Cargando ubicación...';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(user: widget.currentUser),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterAttendanceBody(
                    title: title,
                    currentTime: currentTime,
                    currentDate: currentDate,
                    companyName: companyName,
                  ),
                  AppSizes.gapV24,
                  AttendanceActionButtons(
                    isEntry: widget.isEntry,
                    isLoading: _controller.isLoading,
                    onConfirm: _handleConfirm,
                    onCancel: () => Navigator.pop(context),
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