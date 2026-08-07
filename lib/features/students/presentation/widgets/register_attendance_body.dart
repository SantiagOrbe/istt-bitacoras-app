// lib/features/attendance/presentation/widgets/register_attendance_body.dart
import 'package:bitacoras_app/features/students/attendance.dart';

class RegisterAttendanceBody extends StatelessWidget {
  final String title;
  final String currentTime;
  final String currentDate;
  final String companyName;
  final bool isGpsValid;

  const RegisterAttendanceBody({
    super.key,
    required this.title,
    required this.currentTime,
    required this.currentDate,
    required this.companyName,
    this.isGpsValid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        AppSizes.gapV16,
        
        // 1. AttendanceInfoTile pasando 'time' y 'date'
        AttendanceInfoTile(
          time: currentTime,
          date: currentDate,
        ),
        
        AppSizes.gapV16,
        const MapPreview(),
        AppSizes.gapV16,

        // 2. LocationStatusCard pasando 'isValid'
        LocationStatusCard(
          isValid: isGpsValid,
        ),
        
        AppSizes.gapV16,
        CompanyCard(companyName: companyName),
      ],
    );
  }
}