import 'package:flutter/material.dart';
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
