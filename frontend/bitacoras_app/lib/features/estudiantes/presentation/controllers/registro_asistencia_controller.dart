import 'package:flutter/material.dart';
import '../../domain/models/ubicacion_empresa_model.dart';
import '../../domain/repositories/i_asistencia_repository.dart';

class RegistroAsistenciaController extends ChangeNotifier {
  final IAsistenciaRepository repository;

  RegistroAsistenciaController({required this.repository});

  bool isLoading = false;
  UbicacionEmpresaModel? companyLocation;

  Future<void> init() async {
    notifyListeners();
  }

  Future<bool> confirmAttendance({
    required bool isEntry,
    required double latitude,
    required double longitude,
  }) async {
    isLoading = true;
    notifyListeners();

    final success = await repository.registerAttendance(
      type: isEntry ? 'ENTRY' : 'EXIT',
      latitude: latitude,
      longitude: longitude,
    );

    isLoading = false;
    notifyListeners();

    return success;
  }
}
