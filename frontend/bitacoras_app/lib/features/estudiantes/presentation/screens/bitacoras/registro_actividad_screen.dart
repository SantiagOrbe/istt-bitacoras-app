import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:go_router/go_router.dart';

class RegistroActividadScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAsistenciaRepository attendanceRepository;
  final BitacoraRepositoryImpl bitacoraRepository;

  const RegistroActividadScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
    required this.bitacoraRepository,
  });

  @override
  State<RegistroActividadScreen> createState() =>
      _RegistroActividadScreenState();
}

class _RegistroActividadScreenState extends State<RegistroActividadScreen> {
  late final RegistroActividadController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegistroActividadController(
      repository: widget.attendanceRepository,
      bitacoraRepository: widget.bitacoraRepository,
    );
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveActivities();

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.validationMessage ??
              'Por favor, ingrese al menos una actividad.',
            style: AppTextStyles.body.copyWith(color: AppColors.surface),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Actividades guardadas con éxito!',
          style: AppTextStyles.body.copyWith(color: AppColors.surface),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.go(AppRoutes.registerExitAttendance);
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RegistroActividadHeader(),
                  AppSizes.gapV24,
                  RegistroActividadList(
                    controllers: _controller.controllers,
                    onRemove: _controller.removeActivityField,
                  ),
                  AppSizes.gapV16,
                  RegistroActividadActionButtons(
                    isLoading: _controller.isLoading,
                    enabled: _controller.canRegister,
                    onSave: _handleSave,
                    onAddMore: _controller.addActivityField,
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
