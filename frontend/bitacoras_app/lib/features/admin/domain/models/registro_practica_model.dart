class RegistroPracticaModel {
  final String id;
  final String studentId;
  final String studentName;
  final String companyName;
  final String date;
  final String entryTime;
  final String? exitTime;
  final String activityDescription;
  final String status; // 'Aprobado', 'En curso', 'Desactivado'
  final bool isActive;

  static String formatTimeToAmPm(String? rawTime) {
    if (rawTime == null || rawTime.trim().isEmpty) {
      return 'Sin registro';
    }

    final trimmed = rawTime.trim();
    final parts = trimmed.split(':');

    if (parts.length < 2) {
      return trimmed;
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteText = minute.toString().padLeft(2, '0');

    return '$hour12:$minuteText $period';
  }

  static String normalizeStatus(dynamic value) {
    if (value is bool) {
      return value ? 'En curso' : 'En curso';
    }

    final raw = value?.toString().trim().toLowerCase();
    if (raw == null || raw.isEmpty) {
      return 'En curso';
    }

    switch (raw) {
      case 'aprobado':
      case 'approved':
        return 'Aprobado';
      case 'desactivado':
      case 'inactivo':
      case 'disabled':
      case 'false':
        return 'En curso';
      case 'pendiente':
      case 'pending':
      case 'en espera':
      case 'en revision':
      case 'revision':
        return 'En curso';
      case 'en curso':
      case 'activo':
      case 'active':
      case 'true':
      default:
        return 'En curso';
    }
  }

  static bool normalizeIsActive(dynamic value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }

    final raw = value?.toString().trim().toLowerCase();
    if (raw == null || raw.isEmpty) {
      return fallback;
    }

    switch (raw) {
      case 'desactivado':
      case 'inactivo':
      case 'disabled':
        return false;
      case 'pendiente':
      case 'pending':
      case 'en espera':
      case 'en revision':
      case 'revision':
        return true;
      default:
        return true;
    }
  }

  String get entryTimeLabel => formatTimeToAmPm(entryTime);
  String get exitTimeLabel => formatTimeToAmPm(exitTime);

  const RegistroPracticaModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.companyName,
    required this.date,
    required this.entryTime,
    this.exitTime,
    required this.activityDescription,
    required this.status,
    this.isActive = true,
  });

  RegistroPracticaModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? companyName,
    String? date,
    String? entryTime,
    String? exitTime,
    String? activityDescription,
    String? status,
    bool? isActive,
  }) {
    return RegistroPracticaModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      companyName: companyName ?? this.companyName,
      date: date ?? this.date,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      activityDescription: activityDescription ?? this.activityDescription,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
    );
  }

  factory RegistroPracticaModel.fromJson(Map<String, dynamic> json) {
    final normalizedStatus = normalizeStatus(json['estado'] ?? json['status']);
    final activeValue = json['is_active'] ?? json['estado'];

    return RegistroPracticaModel(
      id: json['id']?.toString() ?? '',
      studentId: (json['student_id'] ?? json['estudiante'])?.toString() ?? '',
      studentName: json['student_name'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      date: json['fecha'] as String? ?? '',
      entryTime: json['hora_entrada'] as String? ?? '',
      exitTime: json['hora_salida'] as String?,
      activityDescription: json['actividad_descripcion'] as String? ?? '',
      status: normalizedStatus,
      isActive: normalizeIsActive(activeValue, fallback: normalizedStatus != 'Desactivado'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'company_name': companyName,
      'fecha': date,
      'hora_entrada': entryTime,
      'hora_salida': exitTime,
      'actividad_descripcion': activityDescription,
      'estado': status == 'Aprobado',
      'is_active': isActive,
    };
  }
}
