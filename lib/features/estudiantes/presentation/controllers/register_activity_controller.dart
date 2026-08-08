import 'package:flutter/material.dart';
import '../../domain/repositories/i_attendance_repository.dart';

class RegisterActivityController extends ChangeNotifier {
  final IAttendanceRepository repository;

  RegisterActivityController({required this.repository});

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

    // Simulación o llamada al repositorio para guardar actividades
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();

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