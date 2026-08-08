import 'package:bitacoras_app/features/estudiantes/domain/models/company_location.dart';

import '../../domain/models/practice_record_model.dart';
import '../../domain/repositories/i_attendance_repository.dart';

class FakeAttendanceRepository implements IAttendanceRepository {
  PracticeRecordModel? _activeRecord = PracticeRecordModel(
    id: '101',
    date: '2026-08-05',
    entryTime: '08:00 AM',
    exitTime: null,
    status: 'En curso',
  );

  @override
  Future<CompanyLocation> getAssignedCompanyLocation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const CompanyLocation(
      name: 'Municipio Tena',
      latitude: -0.9938,
      longitude: -77.8128,
      allowedRadiusMeters: 200.0,
    );
  }

  @override
  Future<PracticeRecordModel?> getCurrentRecord() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _activeRecord;
  }

  @override
  Future<List<PracticeRecordModel>> getAttendanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      if (_activeRecord != null) _activeRecord!,
      PracticeRecordModel(
        id: '100',
        date: '2026-08-04',
        entryTime: '08:00 AM',
        exitTime: '16:00 PM',
        status: 'Completado',
      ),
    ];
  }

  @override
  Future<bool> registerAttendance({
    required String type,
    required double latitude,
    required double longitude,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    if (type == 'EXIT' && _activeRecord != null) {
      _activeRecord = PracticeRecordModel(
        id: _activeRecord!.id,
        date: _activeRecord!.date,
        entryTime: _activeRecord!.entryTime,
        exitTime: '05:00 PM',
        status: 'Completado',
      );
    }
    return true;
  }
}