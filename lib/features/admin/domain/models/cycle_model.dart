class CycleModel {
  final String id;
  final String name;
  final int level;
  final bool isActive;

  const CycleModel({
    required this.id,
    required this.name,
    required this.level,
    this.isActive = true,
  });

  factory CycleModel.fromJson(Map<String, dynamic> json) {
    return CycleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'is_active': isActive,
    };
  }

  CycleModel copyWith({
    String? id,
    String? name,
    int? level,
    bool? isActive,
  }) {
    return CycleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      isActive: isActive ?? this.isActive,
    );
  }
}
