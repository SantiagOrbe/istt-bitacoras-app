class CarreraModel {
  final String id;
  final String name;
  final String code;
  final String shortName;
  final String description;
  final String modality;
  final bool isActive;
  final int totalSemesters;

  const CarreraModel({
    required this.id,
    required this.name,
    required this.code,
    required this.shortName,
    required this.description,
    required this.modality,
    required this.isActive,
    required this.totalSemesters,
  });

  factory CarreraModel.fromJson(Map<String, dynamic> json) {
    return CarreraModel(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] as String? ?? json['name'] as String? ?? '',
      code: json['codigo_carrera'] as String? ?? '',
      shortName: json['sigla_carrera'] as String? ?? '',
      description: json['descripcion'] as String? ?? '',
      modality: json['modalidad'] as String? ?? '',
      isActive: json['estado'] as bool? ?? json['is_active'] as bool? ?? true,
      totalSemesters:
          (json['total_semestres'] ?? json['total_semesters'] as num?) is num
          ? ((json['total_semestres'] ?? json['total_semesters']) as num)
                .toInt()
          : 0,
    );
  }

  factory CarreraModel.desdeJson(Map<String, dynamic> json) =>
      CarreraModel.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'codigo_carrera': code,
      'sigla_carrera': shortName,
      'descripcion': description,
      'modalidad': modality,
      'total_semestres': totalSemesters,
      'estado': isActive,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  CarreraModel copyWith({
    String? id,
    String? name,
    String? code,
    String? shortName,
    String? description,
    String? modality,
    bool? isActive,
    int? totalSemesters,
  }) {
    return CarreraModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      modality: modality ?? this.modality,
      isActive: isActive ?? this.isActive,
      totalSemesters: totalSemesters ?? this.totalSemesters,
    );
  }

  CarreraModel copiarCon({
    String? nuevoId,
    String? nombre,
    String? codigo,
    String? sigla,
    String? descripcion,
    String? modalidad,
    bool? estado,
    int? totalSemestres,
  }) {
    return CarreraModel(
      id: nuevoId ?? id,
      name: nombre ?? name,
      code: codigo ?? code,
      shortName: sigla ?? shortName,
      description: descripcion ?? description,
      modality: modalidad ?? modality,
      isActive: estado ?? isActive,
      totalSemesters: totalSemestres ?? totalSemesters,
    );
  }
}

typedef CarreraModelo = CarreraModel;

extension CarreraModelEspanol on CarreraModel {
  String get nombre => name;
  String get codigo => code;
  String get sigla => shortName;
  String get descripcionCarrera => description;
  String get modalidadCarrera => modality;
  bool get estado => isActive;
  int get totalSemestresCarrera => totalSemesters;

  CarreraModel conNombre(String nuevoNombre) => copyWith(name: nuevoNombre);
  CarreraModel conCodigo(String nuevoCodigo) => copyWith(code: nuevoCodigo);
  CarreraModel conSigla(String nuevaSigla) => copyWith(shortName: nuevaSigla);
  CarreraModel conDescripcion(String nuevaDescripcion) =>
      copyWith(description: nuevaDescripcion);
  CarreraModel conModalidad(String nuevaModalidad) =>
      copyWith(modality: nuevaModalidad);
  CarreraModel conEstado(bool nuevoEstado) => copyWith(isActive: nuevoEstado);
}
