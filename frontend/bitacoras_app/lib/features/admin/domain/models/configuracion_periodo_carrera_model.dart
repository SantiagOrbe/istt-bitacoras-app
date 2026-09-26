class ConfiguracionPeriodoCarreraModel {
  final String careerId;
  final String periodId;
  final List<int> activeSemestersForPractices;

  const ConfiguracionPeriodoCarreraModel({
    required this.careerId,
    required this.periodId,
    required this.activeSemestersForPractices,
  });

  factory ConfiguracionPeriodoCarreraModel.fromJson(Map<String, dynamic> json) {
    return ConfiguracionPeriodoCarreraModel(
      careerId: (json['carrera'] ?? json['career_id'])?.toString() ?? '',
      periodId: (json['periodo'] ?? json['period_id'])?.toString() ?? '',
      activeSemestersForPractices:
          (json['active_semesters'] as List<dynamic>? ?? [])
              .whereType<num>()
              .map((value) => value.toInt())
              .toList(),
    );
  }

  factory ConfiguracionPeriodoCarreraModel.desdeJson(
    Map<String, dynamic> json,
  ) => ConfiguracionPeriodoCarreraModel.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'carrera': careerId,
      'periodo': periodId,
      'active_semesters': activeSemestersForPractices,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  ConfiguracionPeriodoCarreraModel copyWith({
    String? careerId,
    String? periodId,
    List<int>? activeSemestersForPractices,
  }) {
    return ConfiguracionPeriodoCarreraModel(
      careerId: careerId ?? this.careerId,
      periodId: periodId ?? this.periodId,
      activeSemestersForPractices:
          activeSemestersForPractices ?? this.activeSemestersForPractices,
    );
  }

  ConfiguracionPeriodoCarreraModel copiarCon({
    String? nuevaCareerId,
    String? nuevoPeriodId,
    List<int>? semestresActivosPracticas,
  }) {
    return ConfiguracionPeriodoCarreraModel(
      careerId: nuevaCareerId ?? careerId,
      periodId: nuevoPeriodId ?? periodId,
      activeSemestersForPractices:
          semestresActivosPracticas ?? activeSemestersForPractices,
    );
  }
}

typedef ConfiguracionPeriodoCarreraModelo = ConfiguracionPeriodoCarreraModel;

extension ConfiguracionPeriodoCarreraModelEspanol
    on ConfiguracionPeriodoCarreraModel {
  String get carreraId => careerId;
  String get periodoId => periodId;
  List<int> get semestresActivosPracticas => activeSemestersForPractices;

  ConfiguracionPeriodoCarreraModel conCarreraId(String nuevaCarreraId) =>
      copyWith(careerId: nuevaCarreraId);

  ConfiguracionPeriodoCarreraModel conPeriodoId(String nuevoPeriodoId) =>
      copyWith(periodId: nuevoPeriodoId);

  ConfiguracionPeriodoCarreraModel conSemestresActivosPracticas(
    List<int> nuevosSemestres,
  ) => copyWith(activeSemestersForPractices: nuevosSemestres);
}
