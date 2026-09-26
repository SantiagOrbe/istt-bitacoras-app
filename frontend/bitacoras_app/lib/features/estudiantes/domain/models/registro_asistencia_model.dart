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

  String get fecha => date;
  String get horaEntrada => entryTime;
  String? get horaSalida => exitTime;
  String get estado => status;
  bool get tieneActividades => activities.isNotEmpty;

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
  String get etiquetaHoraEntrada => entryTimeLabel;
  String get etiquetaHoraSalida => exitTimeLabel;

  bool get hasActivities => actividades.isNotEmpty;
  bool get actividadesDisponibles => actividades.isNotEmpty;
  List<Map<String, dynamic>> get actividades => activities;

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

  factory RegistroAsistenciaModel.desdeJson(Map<String, dynamic> json) {
    return RegistroAsistenciaModel.fromJson(json);
  }

  // Serialización para peticiones POST/PUT
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': date,
      'hora_entrada': entryTime,
      'hora_salida': exitTime,
      'estado': status,
      'actividades': activities,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  RegistroAsistenciaModel copyWith({
    String? id,
    String? date,
    String? entryTime,
    String? exitTime,
    String? status,
    List<Map<String, dynamic>>? activities,
  }) {
    return RegistroAsistenciaModel(
      id: id ?? this.id,
      date: date ?? this.date,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      status: status ?? this.status,
      activities: activities ?? this.activities,
    );
  }

  RegistroAsistenciaModel copiarCon({
    String? id,
    String? date,
    String? entryTime,
    String? exitTime,
    String? status,
    List<Map<String, dynamic>>? activities,
  }) {
    return copyWith(
      id: id,
      date: date,
      entryTime: entryTime,
      exitTime: exitTime,
      status: status,
      activities: activities,
    );
  }
}

typedef RegistroAsistenciaModelo = RegistroAsistenciaModel;
