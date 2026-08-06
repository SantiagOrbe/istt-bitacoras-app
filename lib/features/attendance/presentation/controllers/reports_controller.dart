import 'package:flutter/material.dart';
import '../../domain/repositories/i_attendance_repository.dart';

class ReportsController extends ChangeNotifier {
  final IAttendanceRepository repository;

  ReportsController({required this.repository});

  bool isGeneratingPdf = false;
  String period = '2023 - 2024 I';
  int completedHours = 120;
  int totalHours = 240;

  Future<bool> generatePdfReport() async {
    isGeneratingPdf = true;
    notifyListeners();

    // Simulación de generación/descarga de PDF vía API
    await Future.delayed(const Duration(seconds: 2));

    isGeneratingPdf = false;
    notifyListeners();

    return true;
  }
}