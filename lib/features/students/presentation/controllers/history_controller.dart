import 'package:flutter/material.dart';
import '../../domain/models/practice_record_model.dart';
import '../../domain/repositories/i_attendance_repository.dart';

class HistoryController extends ChangeNotifier {
  final IAttendanceRepository repository;

  HistoryController({required this.repository});

  bool isLoading = true;
  PracticeRecordModel? activeRecord;
  List<PracticeRecordModel> historyList = [];

  Future<void> fetchHistory() async {
    isLoading = true;
    notifyListeners();

    activeRecord = await repository.getCurrentRecord();
    historyList = await repository.getAttendanceHistory();

    isLoading = false;
    notifyListeners();
  }
}