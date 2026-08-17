import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

enum LocationState { loading, gpsDisabled, invalidError, valid }

class AsistenciaProvider extends ChangeNotifier {
  LocationState _state = LocationState.loading;
  bool _hasCheckedIn = false;
  String? _errorMessage;
  DateTime? _checkInTime;
  String? _assignedCompany;

  // Getters para la UI
  LocationState get state => _state;
  bool get hasCheckedIn => _hasCheckedIn;
  String? get errorMessage => _errorMessage;
  DateTime? get checkInTime => _checkInTime;
  String? get assignedCompany => _assignedCompany;

  /// Verifica servicios, permisos y distancia GPS respecto a las coordenadas objetivo
  Future<void> checkAndVerifyLocation({
    double targetLat =
        -0.9938, // Municipio de Tena / Empresa asignada por defecto
    double targetLng = -77.8128,
    double allowedRadiusMeters = 200.0,
  }) async {
    _state = LocationState.loading;
    _errorMessage = null;
    notifyListeners();

    // 1. Validar si el servicio de ubicación (GPS) está activo
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _state = LocationState.gpsDisabled;
      _errorMessage = "El GPS está desactivado. Debe activarlo para continuar.";
      notifyListeners();
      return;
    }

    // 2. Verificar permisos
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _state = LocationState.gpsDisabled;
        _errorMessage = "Permisos de ubicación denegados.";
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _state = LocationState.gpsDisabled;
      _errorMessage =
          "Los permisos de ubicación están denegados permanentemente en la configuración.";
      notifyListeners();
      return;
    }

    // 3. Obtener ubicación con configuraciones actuales
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLat,
        targetLng,
      );

      if (distanceInMeters <= allowedRadiusMeters) {
        _state = LocationState.valid;
      } else {
        _state = LocationState.invalidError;
        _errorMessage =
            "Te encuentras fuera del rango permitido (${distanceInMeters.round()}m del punto de marcación).";
      }
    } catch (e) {
      _state = LocationState.gpsDisabled;
      _errorMessage = "Error al obtener la ubicación actual: $e";
    }

    notifyListeners();
  }

  /// Registra la entrada del estudiante
  Future<bool> registerCheckIn({String? companyName}) async {
    if (_state != LocationState.valid) return false;

    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulación Async API
    _hasCheckedIn = true;
    _checkInTime = DateTime.now();
    _assignedCompany = companyName ?? 'Empresa Asignada';
    notifyListeners();
    return true;
  }

  /// Resetea o registra la salida
  Future<void> registerCheckOut() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _hasCheckedIn = false;
    _checkInTime = null;
    notifyListeners();
  }

  /// Cierra la aplicación de forma limpia
  void exitApp() {
    SystemNavigator.pop();
  }
}
