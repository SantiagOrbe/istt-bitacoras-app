import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/repositories/bitacora_repository_impl.dart';
import '../../domain/repositories/i_asistencia_repository.dart';

class RegistroActividadController extends ChangeNotifier {
  final IAsistenciaRepository repository;
  final BitacoraRepositoryImpl bitacoraRepository;

  RegistroActividadController({
    required this.repository,
    required this.bitacoraRepository,
  });

  final List<TextEditingController> controllers = [TextEditingController()];
  bool isLoading = false;
  bool canRegister = false;
  String? validationMessage;

  Future<void> init() async {
    await validateLocation();
  }

  Future<bool> validateLocation() async {
    try {
      final company = await repository.getAssignedCompanyLocation();
      if (!await Geolocator.isLocationServiceEnabled()) {
        validationMessage = 'Active el GPS para registrar sus actividades.';
        canRegister = false;
        notifyListeners();
        return false;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        validationMessage = 'Se requieren permisos de ubicación.';
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
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        company.latitude,
        company.longitude,
      );
      canRegister = distance <= company.allowedRadiusMeters;
      validationMessage = canRegister
          ? null
          : 'Está fuera del rango permitido para ${company.name}.';
    } catch (_) {
      canRegister = false;
      validationMessage = 'No se pudo verificar la ubicación actual.';
    }
    notifyListeners();
    return canRegister;
  }

  void addActivityField() {
    controllers.add(TextEditingController());
    notifyListeners();
  }

  void removeActivityField(int index) {
    if (controllers.length > 1) {
      controllers[index].dispose();
      controllers.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> saveActivities() async {
    if (!await validateLocation()) return false;

    final bool hasContent = controllers.any((c) => c.text.trim().isNotEmpty);

    if (!hasContent) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    final currentRecord = await repository.getCurrentRecord();
    if (currentRecord == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      for (final controller in controllers) {
        final description = controller.text.trim();
        if (description.isEmpty) continue;
        await bitacoraRepository.createActivity({
          'descripcion': description,
          'registro_practica': currentRecord.id,
        });
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return true;
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
