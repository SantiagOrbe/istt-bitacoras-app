class CareerModel {
  final String id;
  final String name;
  final int totalSemesters;

  const CareerModel({
    required this.id,
    required this.name,
    required this.totalSemesters,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      totalSemesters: json['total_semesters'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_semesters': totalSemesters,
    };
  }
}