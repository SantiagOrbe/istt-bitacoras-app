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

  UsuarioModel get estudiante => student;
  String get tutorAcademicoId => academicTutorId;
  String get tutorEmpresarialId => companyTutorId;
  String get nombreTutorEmpresarial => companyTutorName;
  String get telefonoTutorEmpresarial => companyTutorPhone;
  double get horasTotalesRequeridas => totalHoursRequired;
  double get horasTotalesCompletadas => totalHoursCompleted;
  String get estado => status;
  String? get ultimaDescripcionActividad => lastActivityDescription;
  String? get ultimaFechaActividad => lastActivityDate;
  String? get ultimaHoraAsistencia => lastAttendanceTime;

  double get remainingHours => (totalHoursRequired - totalHoursCompleted).clamp(0, totalHoursRequired);
  double get progressPercentage => totalHoursRequired > 0 ? (totalHoursCompleted / totalHoursRequired).clamp(0.0, 1.0) : 0.0;
  double get horasRestantes => remainingHours;
  double get porcentajeProgreso => progressPercentage;
  String get totalHoursCompletedLabel => _formatHours(totalHoursCompleted);
  String get totalHoursRequiredLabel => _formatHours(totalHoursRequired);
  String get remainingHoursLabel => _formatHours(remainingHours);
  String get horasCompletadasEtiqueta => totalHoursCompletedLabel;
  String get horasRequeridasEtiqueta => totalHoursRequiredLabel;
  String get horasRestantesEtiqueta => remainingHoursLabel;

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

  factory EstudianteAsignadoModel.desdeJson(Map<String, dynamic> json) {
    return EstudianteAsignadoModel.fromJson(json);
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

  Map<String, dynamic> aJson() => toJson();

  EstudianteAsignadoModel copyWith({
    UsuarioModel? student,
    String? academicTutorId,
    String? companyTutorId,
    String? companyTutorName,
    String? companyTutorPhone,
    double? totalHoursRequired,
    double? totalHoursCompleted,
    String? status,
    String? lastActivityDescription,
    String? lastActivityDate,
    String? lastAttendanceTime,
  }) {
    return EstudianteAsignadoModel(
      student: student ?? this.student,
      academicTutorId: academicTutorId ?? this.academicTutorId,
      companyTutorId: companyTutorId ?? this.companyTutorId,
      companyTutorName: companyTutorName ?? this.companyTutorName,
      companyTutorPhone: companyTutorPhone ?? this.companyTutorPhone,
      totalHoursRequired: totalHoursRequired ?? this.totalHoursRequired,
      totalHoursCompleted: totalHoursCompleted ?? this.totalHoursCompleted,
      status: status ?? this.status,
      lastActivityDescription:
          lastActivityDescription ?? this.lastActivityDescription,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      lastAttendanceTime: lastAttendanceTime ?? this.lastAttendanceTime,
    );
  }

  EstudianteAsignadoModel copiarCon({
    UsuarioModel? student,
    String? academicTutorId,
    String? companyTutorId,
    String? companyTutorName,
    String? companyTutorPhone,
    double? totalHoursRequired,
    double? totalHoursCompleted,
    String? status,
    String? lastActivityDescription,
    String? lastActivityDate,
    String? lastAttendanceTime,
  }) {
    return copyWith(
      student: student,
      academicTutorId: academicTutorId,
      companyTutorId: companyTutorId,
      companyTutorName: companyTutorName,
      companyTutorPhone: companyTutorPhone,
      totalHoursRequired: totalHoursRequired,
      totalHoursCompleted: totalHoursCompleted,
      status: status,
      lastActivityDescription: lastActivityDescription,
      lastActivityDate: lastActivityDate,
      lastAttendanceTime: lastAttendanceTime,
    );
  }
}

typedef EstudianteAsignadoModelo = EstudianteAsignadoModel;
typedef EstudianteAsignado = EstudianteAsignadoModel;