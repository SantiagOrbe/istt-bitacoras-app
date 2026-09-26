class SemestreModel {
  final String id;
  final String careerId;
  final String name;
  final int level;
  final int hoursPracticas;
  final bool isActive;

  const SemestreModel({
    required this.id,
    this.careerId = '',
    required this.name,
    required this.level,
    this.hoursPracticas = 0,
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
      hoursPracticas:
          (json['horas_practicas'] as num?)?.toInt() ??
          (json['hours_practicas'] as num?)?.toInt() ??
          0,
      isActive: json['estado'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }

  factory SemestreModel.desdeJson(Map<String, dynamic> json) =>
      SemestreModel.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'nivel': level,
      'horas_practicas': hoursPracticas,
      'carrera': careerId,
      'estado': isActive,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  SemestreModel copyWith({
    String? id,
    String? careerId,
    String? name,
    int? level,
    int? hoursPracticas,
    bool? isActive,
  }) {
    return SemestreModel(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      name: name ?? this.name,
      level: level ?? this.level,
      hoursPracticas: hoursPracticas ?? this.hoursPracticas,
      isActive: isActive ?? this.isActive,
    );
  }

  SemestreModel copiarCon({
    String? nuevoId,
    String? carreraId,
    String? nombre,
    int? nivel,
    int? horasPracticas,
    bool? estado,
  }) {
    return SemestreModel(
      id: nuevoId ?? id,
      careerId: carreraId ?? careerId,
      name: nombre ?? name,
      level: nivel ?? level,
      hoursPracticas: horasPracticas ?? hoursPracticas,
      isActive: estado ?? isActive,
    );
  }
}

typedef CicloModel = SemestreModel;

typedef SemestreModelo = SemestreModel;

extension SemestreModelEspanol on SemestreModel {
  String get nombre => name;
  String get carreraIdRelacionada => careerId;
  int get nivelSemestre => level;
  int get horasPracticasSemestre => hoursPracticas;
  bool get estado => isActive;

  SemestreModel conNombre(String nuevoNombre) => copyWith(name: nuevoNombre);
  SemestreModel conNivel(int nuevoNivel) => copyWith(level: nuevoNivel);
  SemestreModel conHorasPracticas(int nuevasHoras) =>
      copyWith(hoursPracticas: nuevasHoras);
  SemestreModel conEstado(bool nuevoEstado) => copyWith(isActive: nuevoEstado);
}
