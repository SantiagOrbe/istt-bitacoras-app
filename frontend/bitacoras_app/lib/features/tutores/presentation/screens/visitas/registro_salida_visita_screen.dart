import 'package:intl/intl.dart';
import 'package:bitacoras_app/features/tutores/tutores.dart';

class RegistroSalidaVisitaScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  const RegistroSalidaVisitaScreen({super.key, required this.currentUser});

  @override State<RegistroSalidaVisitaScreen> createState() => _RegistroSalidaVisitaScreenState();
}

class _RegistroSalidaVisitaScreenState extends State<RegistroSalidaVisitaScreen> {
  EstadoVisitaTutorModel? _visit; UbicacionEmpresaModel? _company; Position? _position;
  bool _isLoading = true, _isSaving = false, _isGpsValid = false;
  String? _validationMessage;

  @override void initState() { super.initState(); _loadData(); }

  Future<void> _loadData() async {
    final repo = context.read<IAsistenciaRepositorio>();
    try {
      final visit = await context.read<ITutorRepository>().getTodayVisitStatus();
      _visit = visit;
      if (!visit.puedeRegistrarSalida) {
        _validationMessage = 'Registra y guarda las actividades antes de registrar la salida.';
        return;
      }
      final company = await repo.obtenerUbicacionEmpresaAsignada();
      _company = company;
      if (!await Geolocator.isLocationServiceEnabled()) {
        _validationMessage = 'Activa el GPS para registrar la salida.';
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _validationMessage = 'Se requieren permisos de ubicación para continuar.';
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _position = position;
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        company.latitude,
        company.longitude,
      );
      _isGpsValid = distance <= company.allowedRadiusMeters;
      if (!_isGpsValid) {
        _validationMessage = 'Estás fuera del rango permitido para ${company.name}.';
      }
    } catch (_) {
      _validationMessage = 'No se pudo verificar la visita o la ubicación actual.';
    }
    finally { if (mounted) setState(() => _isLoading = false); }
  }

  Future<void> _handleConfirmExit() async {
    if (!_isGpsValid || _position == null || !(_visit?.puedeRegistrarSalida ?? false)) return;
    setState(() => _isSaving = true);
    try {
      await context
          .read<ITutorRepository>()
          .registerTutorExit(
            latitude: _position!.latitude,
            longitude: _position!.longitude,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Salida registrada con éxito. Visita finalizada.'),
        ),
      );
      context.go(
        '${AppRoutes.inicioTutorAcademico}?refresh=${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo registrar la salida. Inténtalo de nuevo.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override Widget build(BuildContext context) {
    final date = _visit?.fecha ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    final time = DateFormat('hh:mm a').format(DateTime.now());
    final canExit = _isGpsValid && (_visit?.puedeRegistrarSalida ?? false);
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: AppColores.primary)) : SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppTamanos.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegistroAsistenciaBody(title: 'Registrar Salida', currentTime: time, currentDate: date, companyName: _company?.name ?? widget.currentUser.company ?? 'Sin empresa asignada', isGpsValid: _isGpsValid, locationAvailable: _company != null, latitude: _company?.latitude, longitude: _company?.longitude, allowedRadiusMeters: _company?.allowedRadiusMeters, validationMessage: _validationMessage),
              if (_company == null) ...[AppTamanos.gapV16, const UbicacionNoAsignadaCard()],
              AppTamanos.gapV24,
              AsistenciaActionButtons(isEntry: false, isLoading: _isSaving, enabled: canExit, onConfirm: _handleConfirmExit, onCancel: () => context.pop()),
            ],
          ),
        ),
      ),
    );
  }
}
