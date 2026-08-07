class PracticeRecordModel {
  final String id;
  final String date;
  final String entryTime;
  final String? exitTime;
  final String status; // 'Completado' o 'En curso'

  PracticeRecordModel({
    required this.id,
    required this.date,
    required this.entryTime,
    this.exitTime,
    required this.status,
  });

  // Deserialización desde Django API
  factory PracticeRecordModel.fromJson(Map<String, dynamic> json) {
    return PracticeRecordModel(
      id: json['id'].toString(),
      date: json['fecha'] ?? json['date'] ?? '',
      entryTime: json['hora_entrada'] ?? json['horaEntrada'] ?? '',
      exitTime: json['hora_salida'] ?? json['horaSalida'],
      status: json['estado'] ?? json['status'] ?? 'En curso',
    );
  }

  // Serialización para peticiones POST/PUT
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': date,
      'hora_entrada': entryTime,
      'hora_salida': exitTime,
      'estado': status,
    };
  }
}