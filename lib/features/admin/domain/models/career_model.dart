class CareerModel {
  final String id;
  final String name;
  final String code;
  final String shortName;
  final String description;
  final String modality;
  final bool isActive;
  final int totalSemesters;

  const CareerModel({
    required this.id,
    required this.name,
    required this.code,
    required this.shortName,
    required this.description,
    required this.modality,
    required this.isActive,
    required this.totalSemesters,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['codigo_carrera'] as String,
      shortName: json['sigla_carrera'] as String,
      description: json['descripcion'] as String? ?? '',
      modality: json['modalidad'] as String? ?? '',
      isActive: json['estado'] as bool? ?? true,
      totalSemesters: json['total_semesters'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'codigo_carrera': code,
      'sigla_carrera': shortName,
      'descripcion': description,
      'modalidad': modality,
      'estado': isActive,
      'total_semesters': totalSemesters,
    };
  }
}