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

  factory ParaleloModel.fromJson(Map<String, dynamic> json) {
    return ParaleloModel(
      id: json['id'] as String,
      cycleId: json['cycle_id'] as String,
      name: json['name'] as String,
      jornada: json['jornada'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cycle_id': cycleId,
      'name': name,
      'jornada': jornada,
      'is_active': isActive,
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
