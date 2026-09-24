import 'package:bitacoras_app/features/tutores/tutores.dart';

class EstudianteAsignadoModel {
  final UsuarioModel student;
  final String academicTutorId;
  final String companyTutorId;
  final String companyTutorName;
  final String companyTutorPhone;
  final double totalHoursRequired;
  final double totalHoursCompleted;
  final String status; // 'En Proceso', 'Completado', 'Pendiente'
  final String? lastActivityDescription;
  final String? lastActivityDate;
  final String? lastAttendanceTime;

  const EstudianteAsignadoModel({
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

  double get remainingHours => (totalHoursRequired - totalHoursCompleted).clamp(0, totalHoursRequired);
  double get progressPercentage => totalHoursRequired > 0 ? (totalHoursCompleted / totalHoursRequired).clamp(0.0, 1.0) : 0.0;
  String get totalHoursCompletedLabel => _formatHours(totalHoursCompleted);
  String get totalHoursRequiredLabel => _formatHours(totalHoursRequired);
  String get remainingHoursLabel => _formatHours(remainingHours);

  static String _formatHours(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  factory EstudianteAsignadoModel.fromJson(Map<String, dynamic> json) {
    final totalHoursRequiredRaw = json['total_hours_required'];
    final totalHoursCompletedRaw = json['total_hours_completed'];

    return EstudianteAsignadoModel(
      student: UsuarioModel.fromJson(json['student'] ?? {}),
      academicTutorId: json['academic_tutor_id']?.toString() ?? '',
      companyTutorId: json['company_tutor_id']?.toString() ?? '',
      companyTutorName: json['company_tutor_name'] ?? '',
      companyTutorPhone: json['company_tutor_phone'] ?? '',
      totalHoursRequired: _toDouble(totalHoursRequiredRaw, fallback: 240),
      totalHoursCompleted: _toDouble(totalHoursCompletedRaw, fallback: 0),
      status: json['status'] ?? 'En Proceso',
      lastActivityDescription: json['last_activity_description'],
      lastActivityDate: json['last_activity_date'],
      lastAttendanceTime: json['last_attendance_time'],
    );
  }

  static double _toDouble(dynamic value, {required double fallback}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
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