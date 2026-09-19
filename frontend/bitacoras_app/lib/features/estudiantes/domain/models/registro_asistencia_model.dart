class RegistroAsistenciaModel {
  final String id;
  final String date;
  final String entryTime;
  final String? exitTime;
  final String status; // 'Completado' o 'En curso'
  final List<Map<String, dynamic>> activities;

  RegistroAsistenciaModel({
    required this.id,
    required this.date,
    required this.entryTime,
    this.exitTime,
    required this.status,
    this.activities = const [],
  });

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
        activities: (json['actividades'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList(),
    );
  }

      bool get hasActivities => activities.isNotEmpty;

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
