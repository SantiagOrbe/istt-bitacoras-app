import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  /// Verifica si el GPS está activo al entrar
  Future<void> _checkInitialLocation() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      _showLocationDisabledDialog();
    }
  }

  /// Escucha en tiempo real si el estudiante apaga/enciende el GPS
  void _startListeningLocationStatus() {
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        _showLocationDisabledDialog();
      } else if (status == ServiceStatus.enabled && _isDialogShowing) {
        // Si reactiva el GPS, cerramos el diálogo automáticamente
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
      barrierDismissible: false, // Bloquea clics fuera
      builder: (context) {
        return PopScope(
          canPop: false, // Bloquea botón atrás de Android
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.location_off_rounded, color: Colors.redAccent, size: 28),
                SizedBox(width: 10),
                Text('GPS Desactivado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              'Es necesario mantener el GPS activo para validar tus asistencias e historial de prácticas.',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4C81),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                },
                child: const Text('Activar Ubicación', style: TextStyle(color: Colors.white)),
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