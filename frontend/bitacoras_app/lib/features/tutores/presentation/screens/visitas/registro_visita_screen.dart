import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../../../app/apps.dart';
import 'package:provider/provider.dart';

class RegistroVisitaScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const RegistroVisitaScreen({super.key, required this.currentUser});

  @override
  State<RegistroVisitaScreen> createState() => _RegistroVisitaScreenState();
}

class _RegistroVisitaScreenState extends State<RegistroVisitaScreen> {
  final FakeTutorRepository _repo = FakeTutorRepository();
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
      await _repo.registerTutorEntry(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registrar Entrada',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    
                    // Tarjeta HORA / FECHA
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 28),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('HORA', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                Text(DateFormat('hh:mm a').format(now), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Spacer(),
                            Container(width: 1, height: 30, color: AppColors.divider),
                            const Spacer(),
                            const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 28),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('FECHA', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                Text(DateFormat('yyyy-MM-dd').format(now), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    MapaPreview(
                      latitude: _companyLocation?.latitude,
                      longitude: _companyLocation?.longitude,
                      radiusInMeters: _companyLocation?.allowedRadiusMeters ?? 200,
                      isGpsActive: _currentPosition != null,
                      statusLabel: _currentPosition == null ? 'GPS no validado' : 'GPS Activo',
                    ),
                    const SizedBox(height: 16),

                    if (!_canRegister)
                      UbicacionNoAsignadaCard(
                        title: _companyLocation == null ? 'Empresa no asignada' : _warningTitle,
                        message: _companyLocation == null
                            ? 'No hay una empresa asignada con ubicación GPS para este tutor. El responsable de prácticas debe completar la asignación.'
                            : _validationMessage,
                      ),
                    if (!_canRegister)
                      const SizedBox(height: 16),

                    // Empresa / Lugar Precargado
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.business, color: AppColors.primary),
                        title: Text(_companyLocation?.name ?? 'Sin empresa asignada', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: _companyLocation == null
                          ? const Text('El tutor no tiene una empresa con ubicación configurada.')
                          : Text('Radio permitido: ${_companyLocation!.allowedRadiusMeters.toStringAsFixed(0)} m'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón Confirmar Entrada
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.login_rounded, color: Colors.white),
                        label: const Text('Confirmar Entrada', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        onPressed: _canRegister ? _confirmArrival : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botón Cancelar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => context.pop(),
                        child: const Text('Cancelar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}