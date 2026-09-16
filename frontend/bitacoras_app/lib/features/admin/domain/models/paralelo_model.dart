class ParaleloModel {
  final String id;
  final String cycleId;
  final String name;
  final String jornada;
  final bool isActive;

  const ParaleloModel({
    required this.id,
    required this.cycleId,
    required this.name,
    required this.jornada,
    this.isActive = true,
  });

  String get semesterId => cycleId;

  factory ParaleloModel.fromJson(Map<String, dynamic> json) {
    return ParaleloModel(
      id: json['id']?.toString() ?? '',
      cycleId:
          (json['semestre'] ??
                  json['semester_id'] ??
                  json['ciclo'] ??
                  json['cycle_id'])
              ?.toString() ??
          '',
      name: json['nombre'] as String? ?? json['name'] as String? ?? '',
      jornada: json['jornada'] as String? ?? '',
      isActive: json['estado'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'semestre': cycleId,
      'nombre': name,
      'jornada': jornada,
      'estado': isActive,
    };
  }

  ParaleloModel copyWith({
    String? id,
    String? cycleId,
    String? name,
    String? jornada,
    bool? isActive,
  }) {
    return ParaleloModel(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      name: name ?? this.name,
      jornada: jornada ?? this.jornada,
      isActive: isActive ?? this.isActive,
    );
  }
}
