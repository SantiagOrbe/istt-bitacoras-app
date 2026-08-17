class PeriodoModel {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const PeriodoModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  factory PeriodoModel.fromJson(Map<String, dynamic> json) {
    return PeriodoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['fecha_inicio'] as String),
      endDate: DateTime.parse(json['fecha_fin'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fecha_inicio': startDate.toIso8601String(),
      'fecha_fin': endDate.toIso8601String(),
      'is_active': isActive,
    };
  }

  PeriodoModel copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return PeriodoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}