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
      activeSemestersForPractices: (json['active_semesters'] as List<dynamic>? ?? [])
          .whereType<num>()
          .map((value) => value.toInt())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'career_id': careerId,
      'period_id': periodId,
      'active_semesters': activeSemestersForPractices,
    };
  }
}