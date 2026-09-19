import 'package:bitacoras_app/features/estudiantes/data/services/reporte_practica_pdf_service.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../../domain/repositories/i_asistencia_repository.dart';

class ReportesController extends ChangeNotifier {
  final IAsistenciaRepository repository;
  final UsuarioModel currentUser;

  ReportesController({
    required this.repository,
    required this.currentUser,
  });

  bool isGeneratingPdf = false;
  String period = '';
  int completedHours = 0;
  int totalHours = 0;
  List<RegistroAsistenciaModel> history = const [];

  Future<void> loadReportData() async {
    try {
      final records = await repository.getAttendanceHistory();
      final progress = await repository.getStudentPracticeProgress();
      final accumulated = (progress['horas_acumuladas'] as num?)?.toDouble() ?? 0.0;
      final required = (progress['horas_requeridas'] as num?)?.toDouble() ?? 0.0;

      period = currentUser.semestreNombre ?? currentUser.periodName ?? 'Semestre actual';
      completedHours = accumulated.round();
      totalHours = required.round() > 0 ? required.round() : currentUser.horasPracticas;
      history = records;
    } catch (_) {
      period = currentUser.semestreNombre ?? 'Semestre actual';
      completedHours = 0;
      totalHours = currentUser.horasPracticas;
      history = const [];
    }
    notifyListeners();
  }

  Future<String> generatePdfReport() async {
    isGeneratingPdf = true;
    notifyListeners();

    try {
      final path = await ReportePracticaPdfService.saveToFile(
        user: currentUser,
        history: history,
      );

      if (path.isNotEmpty) {
        try {
          await OpenFile.open(path);
        } catch (_) {
          // The file was already saved successfully; the open step is best-effort.
        }

        isGeneratingPdf = false;
        notifyListeners();
        return 'Generacion de pdf completa';
      }

      isGeneratingPdf = false;
      notifyListeners();
      return 'No se pudo generar el PDF.';
    } catch (_) {
      isGeneratingPdf = false;
      notifyListeners();
      return 'No se pudo generar el PDF.';
    }
  }
}
