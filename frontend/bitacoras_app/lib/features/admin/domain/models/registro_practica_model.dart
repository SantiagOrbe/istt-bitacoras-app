class RegistroPracticaModel {
  final String id;
  final String studentId;
  final String studentName;
  final String companyName;
  final String date;
  final String entryTime;
  final String? exitTime;
  final String activityDescription;
  final String status; // 'Aprobado', 'Pendiente', 'Rechazado'

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
  });

  factory RegistroPracticaModel.fromJson(Map<String, dynamic> json) {
    return RegistroPracticaModel(
      id: json['id']?.toString() ?? '',
      studentId: (json['student_id'] ?? json['estudiante'])?.toString() ?? '',
      studentName: json['student_name'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      date: json['fecha'] as String? ?? '',
      entryTime: json['hora_entrada'] as String? ?? '',
      exitTime: json['hora_salida'] as String?,
      activityDescription: json['actividad_descripcion'] as String? ?? '',
      status: json['estado'] is bool
          ? (json['estado'] as bool ? 'Aprobado' : 'Pendiente')
          : json['estado'] as String? ?? 'Pendiente',
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
      'estado': status,
    };
  }
}
