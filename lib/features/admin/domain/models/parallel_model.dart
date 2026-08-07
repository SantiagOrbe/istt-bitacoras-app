class ParallelModel {
  final String id;
  final String cycleId;
  final String name;
  final String jornada;
  final bool isActive;

  const ParallelModel({
    required this.id,
    required this.cycleId,
    required this.name,
    required this.jornada,
    this.isActive = true,
  });

  factory ParallelModel.fromJson(Map<String, dynamic> json) {
    return ParallelModel(
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

  ParallelModel copyWith({
    String? id,
    String? cycleId,
    String? name,
    String? jornada,
    bool? isActive,
  }) {
    return ParallelModel(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      name: name ?? this.name,
      jornada: jornada ?? this.jornada,
      isActive: isActive ?? this.isActive,
    );
  }
}
