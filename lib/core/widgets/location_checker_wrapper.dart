import 'dart:async';
import 'package:geolocator/geolocator.dart';

// Exports compartidos desde el archivo shared/exports.dart
import 'package:bitacoras_app/shared/exports.dart';


class LocationCheckerWrapper extends StatefulWidget {
  final Widget child;

  const LocationCheckerWrapper({super.key, required this.child});

  @override
  State<LocationCheckerWrapper> createState() => _LocationCheckerWrapperState();
}

class _LocationCheckerWrapperState extends State<LocationCheckerWrapper> {
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _checkInitialLocation();
    _startListeningLocationStatus();
  }

  /// Verifica si el GPS está activo al iniciar la vista
  Future<void> _checkInitialLocation() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      _showLocationDisabledDialog();
    }
  }

  /// Escucha en tiempo real el cambio de estado del GPS
  void _startListeningLocationStatus() {
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        _showLocationDisabledDialog();
      } else if (status == ServiceStatus.enabled && _isDialogShowing) {
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        _isDialogShowing = false;
      }
    });
  }

  void _showLocationDisabledDialog() {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.location_off_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
                AppSizes.gapH8,
                Text(
                  'GPS Desactivado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Es necesario mantener el GPS activo para validar tus asistencias e historial de prácticas.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                ),
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                },
                child: const Text(
                  'Activar Ubicación',
                  style: TextStyle(color: AppColors.surface),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) => _isDialogShowing = false);
  }

  @override
  void dispose() {
    _serviceStatusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}