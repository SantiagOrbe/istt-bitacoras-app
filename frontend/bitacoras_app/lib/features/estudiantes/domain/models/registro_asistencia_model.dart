class RegistroAsistenciaModel {
  final String id;
  final String date;
  final String entryTime;
  final String? exitTime;
  final String status; // 'Completado' o 'En curso'

  RegistroAsistenciaModel({
    required this.id,
    required this.date,
    required this.entryTime,
    this.exitTime,
    required this.status,
  });

  // Deserialización desde Django API
  factory RegistroAsistenciaModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['estado'] ?? json['status'];

    return RegistroAsistenciaModel(
      id: json['id']?.toString() ?? '',
      date: (json['fecha'] ?? json['date']) as String? ?? '',
      entryTime: (json['hora_entrada'] ?? json['horaEntrada']) as String? ?? '',
      exitTime: (json['hora_salida'] ?? json['horaSalida']) as String?,
      status: rawStatus is bool
          ? (rawStatus ? 'En curso' : 'Completado')
          : rawStatus as String? ?? 'En curso',
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
