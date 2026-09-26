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

  factory ParaleloModel.desdeJson(Map<String, dynamic> json) =>
      ParaleloModel.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'semestre': cycleId,
      'nombre': name,
      'jornada': jornada,
      'estado': isActive,
    };
  }

  Map<String, dynamic> aJson() => toJson();

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

  ParaleloModel copiarCon({
    String? nuevoId,
    String? cicloId,
    String? nombre,
    String? jornadaParalelo,
    bool? estado,
  }) {
    return ParaleloModel(
      id: nuevoId ?? id,
      cycleId: cicloId ?? cycleId,
      name: nombre ?? name,
      jornada: jornadaParalelo ?? jornada,
      isActive: estado ?? isActive,
    );
  }
}

typedef ParaleloModelo = ParaleloModel;

extension ParaleloModelEspanol on ParaleloModel {
  String get nombre => name;
  String get cicloId => cycleId;
  String get jornadaParalelo => jornada;
  bool get estado => isActive;
  String get semestreId => cycleId;

  ParaleloModel conNombre(String nuevoNombre) => copyWith(name: nuevoNombre);
  ParaleloModel conCicloId(String nuevoCicloId) =>
      copyWith(cycleId: nuevoCicloId);
  ParaleloModel conJornada(String nuevaJornada) =>
      copyWith(jornada: nuevaJornada);
  ParaleloModel conEstado(bool nuevoEstado) => copyWith(isActive: nuevoEstado);
}
