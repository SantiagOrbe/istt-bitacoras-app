import 'package:bitacoras_app/features/home/domain/models/user_model.dart';

class AssignedStudentModel {
  final UserModel student;
  final String academicTutorId;
  final String companyTutorId;
  final String companyTutorName;
  final String companyTutorPhone;
  final int totalHoursRequired;
  final int totalHoursCompleted;
  final String status; // 'En Proceso', 'Completado', 'Pendiente'
  final String? lastActivityDescription;
  final String? lastActivityDate;
  final String? lastAttendanceTime;

  const AssignedStudentModel({
    required this.student,
    required this.academicTutorId,
    required this.companyTutorId,
    this.companyTutorName = '',
    this.companyTutorPhone = '',
    this.totalHoursRequired = 240,
    this.totalHoursCompleted = 0,
    this.status = 'En Proceso',
    this.lastActivityDescription,
    this.lastActivityDate,
    this.lastAttendanceTime,
  });

  int get remainingHours => (totalHoursRequired - totalHoursCompleted).clamp(0, totalHoursRequired);
  double get progressPercentage => totalHoursRequired > 0 ? (totalHoursCompleted / totalHoursRequired).clamp(0.0, 1.0) : 0.0;

  factory AssignedStudentModel.fromJson(Map<String, dynamic> json) {
    return AssignedStudentModel(
      student: UserModel.fromJson(json['student'] ?? {}),
      academicTutorId: json['academic_tutor_id']?.toString() ?? '',
      companyTutorId: json['company_tutor_id']?.toString() ?? '',
      companyTutorName: json['company_tutor_name'] ?? '',
      companyTutorPhone: json['company_tutor_phone'] ?? '',
      totalHoursRequired: json['total_hours_required'] ?? 240,
      totalHoursCompleted: json['total_hours_completed'] ?? 0,
      status: json['status'] ?? 'En Proceso',
      lastActivityDescription: json['last_activity_description'],
      lastActivityDate: json['last_activity_date'],
      lastAttendanceTime: json['last_attendance_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student': student.toJson(),
      'academic_tutor_id': academicTutorId,
      'company_tutor_id': companyTutorId,
      'company_tutor_name': companyTutorName,
      'company_tutor_phone': companyTutorPhone,
      'total_hours_required': totalHoursRequired,
      'total_hours_completed': totalHoursCompleted,
      'status': status,
      'last_activity_description': lastActivityDescription,
      'last_activity_date': lastActivityDate,
      'last_attendance_time': lastAttendanceTime,
    };
  }
}