import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:intl/intl.dart';

class RegistroAsistenciaScreen extends StatefulWidget {
  final bool isEntry;
  final String? timeLabel;
  final String? dateLabel;
  final UsuarioModel currentUser;
  final IAsistenciaRepository attendanceRepository;
  final BitacoraRepositoryImpl bitacoraRepository;

  const RegistroAsistenciaScreen({
    super.key,
    this.isEntry = true,
    this.timeLabel,
    this.dateLabel,
    required this.currentUser,
    required this.attendanceRepository,
    required this.bitacoraRepository,
  });

  @override
  State<RegistroAsistenciaScreen> createState() =>
      _RegistroAsistenciaScreenState();
}

class _RegistroAsistenciaScreenState extends State<RegistroAsistenciaScreen> {
  late final RegistroAsistenciaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegistroAsistenciaController(
      repository: widget.attendanceRepository,
    );
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
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEntry
                ? '¡Entrada registrada con éxito!'
                : '¡Salida registrada con éxito!',
            style: AppTextStyles.body.copyWith(color: AppColors.surface),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (widget.isEntry) {
        context.go(AppRoutes.studentHome);
      } else {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildWarningCard(String title, String message) {
    return InstitutionalGlowCard(
      accentColor: AppColors.error,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_off_rounded,
                color: AppColors.error,
                size: 28,
              ),
              AppSizes.gapH8,
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          AppSizes.gapV8,
          Text(
            message,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEntry ? 'Registrar Entrada' : 'Registrar Salida';
    final now = DateTime.now();
    final currentTime =
        widget.timeLabel ?? DateFormat('hh:mm a').format(now);
    final currentDate = widget.dateLabel ?? DateFormat('dd/MM/yyyy').format(now);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final companyName =
            _controller.companyLocation?.name ?? 'Sin empresa asignada';
        final shouldShowWarning = !_controller.hasCompanyAssigned ||
            !_controller.canRegister;

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
                  if (shouldShowWarning)
                    _buildWarningCard(
                      _controller.warningTitle,
                      _controller.validationMessage ??
                          'Usted no tiene empresa asignada. Comuníquese con el responsable del proceso de prácticas para que le asigne una empresa.',
                    ),
                  RegistroAsistenciaBody(
                    title: title,
                    currentTime: currentTime,
                    currentDate: currentDate,
                    companyName: companyName,
                    isGpsValid: _controller.canRegister,
                    locationAvailable: _controller.companyLocation != null,
                    latitude: _controller.companyLocation?.latitude,
                    longitude: _controller.companyLocation?.longitude,
                    allowedRadiusMeters:
                        _controller.companyLocation?.allowedRadiusMeters,
                  ),
                  AppSizes.gapV24,
                  AsistenciaActionButtons(
                    isEntry: widget.isEntry,
                    isLoading: _controller.isLoading,
                    enabled: _controller.canRegister,
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
