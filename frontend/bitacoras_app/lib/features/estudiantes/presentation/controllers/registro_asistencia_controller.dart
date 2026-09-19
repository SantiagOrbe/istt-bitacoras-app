import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/models/ubicacion_empresa_model.dart';
import '../../domain/repositories/i_asistencia_repository.dart';

class RegistroAsistenciaController extends ChangeNotifier {
  final IAsistenciaRepository repository;

  RegistroAsistenciaController({required this.repository});

  bool isLoading = false;
  bool canRegister = false;
  bool hasCompanyAssigned = false;
  bool hasReachedHourLimit = false;
  UbicacionEmpresaModel? companyLocation;
  Position? currentPosition;
  String? validationMessage;
  String warningTitle = 'Empresa no asignada';

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    try {
      companyLocation = await repository.getAssignedCompanyLocation();
      hasCompanyAssigned = true;
    } catch (error) {
      companyLocation = null;
      canRegister = false;
      final errorMessage = error is ApiException
          ? error.message
          : error is StateError
              ? error.message
              : 'No se pudo cargar la empresa asignada.';
      final hasNoCompany = errorMessage.toLowerCase().contains(
        'no tiene una empresa asignada',
      );
      hasCompanyAssigned = !hasNoCompany;
      warningTitle = hasNoCompany
          ? 'Empresa no asignada'
          : 'No se pudo cargar la ubicación';
      validationMessage = hasNoCompany
          ? 'Usted no tiene empresa asignada. Comuníquese con el responsable del proceso de prácticas para que le asigne una empresa.'
          : errorMessage;
      isLoading = false;
      notifyListeners();
      return;
    }

    await _loadPracticeProgress();
    await validateLocation();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadPracticeProgress() async {
    try {
      final progress = await repository.getStudentPracticeProgress();
      final completo = progress['completo'] == true;
      hasReachedHourLimit = completo;

      if (completo) {
        warningTitle = 'Límite de horas alcanzado';
        validationMessage =
            'Ya completaste tus horas requeridas del semestre. No puedes registrar más entradas.';
      }
    } catch (_) {
      hasReachedHourLimit = false;
    }
  }

  Future<bool> validateLocation() async {
    if (!hasCompanyAssigned || companyLocation == null) {
      validationMessage =
          'Usted no tiene empresa asignada. Comuníquese con el responsable del proceso de prácticas para que le asigne una empresa.';
      canRegister = false;
      notifyListeners();
      return false;
    }

    if (hasReachedHourLimit) {
      warningTitle = 'Límite de horas alcanzado';
      validationMessage =
          'Ya completaste tus horas requeridas del semestre. No puedes registrar más entradas.';
      canRegister = false;
      notifyListeners();
      return false;
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        warningTitle = 'GPS desactivado';
        validationMessage =
            'El GPS está desactivado. Active la ubicación para registrar la asistencia.';
        canRegister = false;
        notifyListeners();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          warningTitle = 'Permiso de ubicación requerido';
          validationMessage =
              'Se requieren permisos de ubicación para registrar la asistencia.';
          canRegister = false;
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        warningTitle = 'Permiso de ubicación bloqueado';
        validationMessage =
            'Los permisos de ubicación están denegados permanentemente. Actívelos en la configuración.';
        canRegister = false;
        notifyListeners();
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      currentPosition = position;

      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        companyLocation!.latitude,
        companyLocation!.longitude,
      );

      if (distanceInMeters <= companyLocation!.allowedRadiusMeters) {
        validationMessage = null;
        canRegister = !hasReachedHourLimit;
        notifyListeners();
        return !hasReachedHourLimit;
      }

      warningTitle = 'Fuera del rango permitido';
      validationMessage =
          'No se encuentra dentro del rango permitido para ${companyLocation!.name}.';
      canRegister = false;
      notifyListeners();
      return false;
    } catch (_) {
      warningTitle = 'Ubicación no disponible';
      validationMessage =
          'No se pudo verificar su ubicación en este momento. Inténtelo nuevamente.';
      canRegister = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> confirmAttendance({
    required bool isEntry,
  }) async {
    final isValid = await validateLocation();
    if (!isValid) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    final position = currentPosition;
    if (position == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    final success = await repository.registerAttendance(
      type: isEntry ? 'ENTRY' : 'EXIT',
      latitude: position.latitude,
      longitude: position.longitude,
    );

    isLoading = false;
    notifyListeners();

    return success;
  }
}
