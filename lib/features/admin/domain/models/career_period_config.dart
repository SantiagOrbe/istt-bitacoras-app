class CareerPeriodConfig {
  final String careerId;
  final String periodId;
  final List<int> activeSemestersForPractices;

  const CareerPeriodConfig({
    required this.careerId,
    required this.periodId,
    required this.activeSemestersForPractices,
  });

  factory CareerPeriodConfig.fromJson(Map<String, dynamic> json) {
    return CareerPeriodConfig(
      careerId: json['career_id'] as String,
      periodId: json['period_id'] as String,
      activeSemestersForPractices: List<int>.from(json['active_semesters'] ?? []),
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