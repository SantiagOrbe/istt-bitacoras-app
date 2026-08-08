import 'package:flutter/material.dart';
import '../../domain/models/company_location.dart';
import '../../domain/repositories/i_attendance_repository.dart';

class RegisterAttendanceController extends ChangeNotifier {
  final IAttendanceRepository repository;

  RegisterAttendanceController({required this.repository});

  bool isLoading = false;
  CompanyLocation? companyLocation;

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