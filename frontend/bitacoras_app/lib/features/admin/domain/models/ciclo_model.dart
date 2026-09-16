class SemestreModel {
  final String id;
  final String careerId;
  final String name;
  final int level;
  final bool isActive;

  const SemestreModel({
    required this.id,
    this.careerId = '',
    required this.name,
    required this.level,
    this.isActive = true,
  });

  factory SemestreModel.fromJson(Map<String, dynamic> json) {
    return SemestreModel(
      id: json['id']?.toString() ?? '',
      careerId: (json['carrera'] ?? json['career_id'])?.toString() ?? '',
      name: json['nombre'] as String? ?? json['name'] as String? ?? '',
      level:
          (json['nivel'] as num?)?.toInt() ??
          (json['level'] as num?)?.toInt() ??
          0,
      isActive: json['estado'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'nivel': level,
      'carrera': careerId,
      'estado': isActive,
    };
  }

  SemestreModel copyWith({
    String? id,
    String? careerId,
    String? name,
    int? level,
    bool? isActive,
  }) {
    return SemestreModel(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      name: name ?? this.name,
      level: level ?? this.level,
      isActive: isActive ?? this.isActive,
    );
  }
}

typedef CicloModel = SemestreModel;
