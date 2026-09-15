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