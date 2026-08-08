
import 'package:bitacoras_app/features/estudiantes/domain/models/company_location.dart';

import '../models/practice_record_model.dart';

abstract class IAttendanceRepository {
  Future<CompanyLocation> getAssignedCompanyLocation();
  Future<PracticeRecordModel?> getCurrentRecord();
  Future<List<PracticeRecordModel>> getAttendanceHistory();
  Future<bool> registerAttendance({
    required String type, // 'ENTRY' o 'EXIT'
    required double latitude,
    required double longitude,
  });
}