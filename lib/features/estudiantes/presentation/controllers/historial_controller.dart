import 'package:flutter/material.dart';
import '../../domain/models/registro_asistencia_model.dart';
import '../../domain/repositories/i_asistencia_repository.dart';

class HistorialController extends ChangeNotifier {
  final IAsistenciaRepository repository;

  HistorialController({required this.repository});

  bool isLoading = true;
  RegistroAsistenciaModel? activeRecord;
  List<RegistroAsistenciaModel> historyList = [];

  Future<void> fetchHistory() async {
    isLoading = true;
    notifyListeners();

    activeRecord = await repository.getCurrentRecord();
    historyList = await repository.getAttendanceHistory();

    isLoading = false;
    notifyListeners();
  }
}
