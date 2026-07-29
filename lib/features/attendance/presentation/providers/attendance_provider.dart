import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

enum LocationState { loading, gpsDisabled, invalidError, valid }

class AttendanceProvider extends ChangeNotifier {
  LocationState _state = LocationState.loading;
  bool _hasCheckedIn = false; // Estado global para el Home
  String? _errorMessage;

  LocationState get state => _state;
  bool get hasCheckedIn => _hasCheckedIn;
  String? get errorMessage => _errorMessage;

  get checkInTime => null;

  String? get assignedCompany => null;

  // Verificar si el GPS del sistema está activo y si hay permisos
  Future<void> checkAndVerifyLocation() async {
    _state = LocationState.loading;
    notifyListeners();

    // 1. Comprobar si los servicios de ubicación (GPS) están encendidos en el teléfono
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _state = LocationState.gpsDisabled;
      _errorMessage = "El GPS está desactivado. Debe activarlo para continuar.";
      notifyListeners();
      return;
    }

    // 2. Comprobar permisos de ubicación
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
      _errorMessage = "Los permisos de ubicación están denegados permanentemente.";
      notifyListeners();
      return;
    }

    // 3. Si el GPS está encendido y hay permiso -> obtener posición real
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Distancia de prueba hacia el Municipio de Tena (-0.9938, -77.8128)
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        -0.9938,
        -77.8128,
      );

      if (distanceInMeters <= 200) { // Radio de 200m
        _state = LocationState.valid;
      } else {
        _state = LocationState.invalidError;
      }
    } catch (e) {
      _state = LocationState.gpsDisabled;
      _errorMessage = "Error al obtener la ubicación.";
    }

    notifyListeners();
  }

  // Registrar entrada exitosa
  Future<bool> registerCheckIn() async {
    if (_state != LocationState.valid) return false;
    
    await Future.delayed(const Duration(seconds: 1));
    _hasCheckedIn = true; // Actualiza el estado
    notifyListeners();
    return true;
  }

  // Cierra la aplicación si no activa el GPS
  void exitApp() {
    SystemNavigator.pop(); // Cierra la app en Android/iOS de forma limpia
  }

  void verifyLocation({required bool simulateSuccess}) {}

  Future<void> confirmAttendance(String s) async {}
}