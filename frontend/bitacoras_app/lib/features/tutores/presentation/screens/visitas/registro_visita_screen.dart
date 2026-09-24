import 'package:bitacoras_app/features/tutores/tutores.dart';
import 'package:intl/intl.dart';


class RegistroVisitaScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const RegistroVisitaScreen({super.key, required this.currentUser});

  @override
  State<RegistroVisitaScreen> createState() => _RegistroVisitaScreenState();
}

class _RegistroVisitaScreenState extends State<RegistroVisitaScreen> {
  UbicacionEmpresaModel? _companyLocation;
  Position? _currentPosition;
  bool _isLoading = true;
  bool _canRegister = false;
  String _warningTitle = 'Validando ubicación';
  String _validationMessage = 'Verificando la empresa asignada y la ubicación GPS.';

  @override
  void initState() {
    super.initState();
    _validateLocation();
  }

  Future<void> _validateLocation() async {
    setState(() {
      _isLoading = true;
      _canRegister = false;
    });

    try {
      final location = await context.read<IAsistenciaRepository>().getAssignedCompanyLocation();
      _companyLocation = location;

      if (!await Geolocator.isLocationServiceEnabled()) {
        _warningTitle = 'GPS desactivado';
        _validationMessage = 'Active el GPS para comprobar que se encuentra en la empresa asignada.';
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _warningTitle = 'Permiso de ubicación requerido';
        _validationMessage = 'No se obtuvo permiso para consultar su ubicación. Actívelo e inténtelo nuevamente.';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _currentPosition = position;
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        location.latitude,
        location.longitude,
      );

      if (distance <= location.allowedRadiusMeters) {
        _canRegister = true;
        _warningTitle = 'Ubicación validada';
        _validationMessage = 'Se encuentra dentro del rango de ${location.name}.';
      } else {
        _warningTitle = 'Fuera de la empresa asignada';
        _validationMessage = 'No se encuentra dentro del rango permitido de ${location.name}.';
      }
    } catch (_) {
      _companyLocation = null;
      _warningTitle = 'Ubicación no disponible';
      _validationMessage = 'No se obtuvo la ubicación de la empresa. Inténtelo nuevamente más tarde.';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmArrival() async {
    if (!_canRegister || _currentPosition == null) return;

    try {
      await context.read<ITutorRepository>().registerTutorEntry(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrada registrada correctamente.')),
      );
      context.go(
        '${AppRoutes.academicTutorHome}?refresh=${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo registrar la entrada: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return LocationCheckerWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: InicioAppBar(user: widget.currentUser),
        body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegistroAsistenciaBody(
                      title: 'Registrar Entrada',
                      currentTime: DateFormat('hh:mm a').format(now),
                      currentDate: DateFormat('yyyy-MM-dd').format(now),
                      companyName: _companyLocation?.name ?? 'Sin empresa asignada',
                      isGpsValid: _canRegister,
                      locationAvailable: _companyLocation != null,
                      latitude: _companyLocation?.latitude,
                      longitude: _companyLocation?.longitude,
                      allowedRadiusMeters: _companyLocation?.allowedRadiusMeters,
                      validationMessage: _canRegister ? null : _validationMessage,
                    ),
                    if (!_canRegister) ...[
                      AppSizes.gapV12,
                      UbicacionNoAsignadaCard(
                        title: _companyLocation == null ? 'Empresa no asignada' : _warningTitle,
                        message: _companyLocation == null
                            ? 'No hay una empresa asignada con ubicación GPS para este tutor.'
                            : _validationMessage,
                      ),
                    ],
                    AppSizes.gapV24,
                    AsistenciaActionButtons(
                      isEntry: true,
                      isLoading: false,
                      enabled: _canRegister,
                      onConfirm: _confirmArrival,
                      onCancel: () => context.pop(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}