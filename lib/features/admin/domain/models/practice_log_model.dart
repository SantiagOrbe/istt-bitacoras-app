class PracticeLogModel {
  final String id;
  final String studentId;
  final String studentName;
  final String companyName;
  final String date;
  final String entryTime;
  final String? exitTime;
  final String activityDescription;
  final String status; // 'Aprobado', 'Pendiente', 'Rechazado'

  const PracticeLogModel({
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

  factory PracticeLogModel.fromJson(Map<String, dynamic> json) {
    return PracticeLogModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      studentName: json['student_name'] ?? '',
      companyName: json['company_name'] ?? '',
      date: json['fecha'] ?? '',
      entryTime: json['hora_entrada'] ?? '',
      exitTime: json['hora_salida'],
      activityDescription: json['actividad_descripcion'] ?? '',
      status: json['estado'] ?? 'Pendiente',
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