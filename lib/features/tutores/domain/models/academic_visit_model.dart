class AcademicVisitModel {
  final String id;
  final String studentId;
  final String studentName;
  final String companyName;
  final String companyTutorName;
  final String career;
  final String date;
  final String? arrivalTime;
  final String? departureTime;
  final String activities;
  final String observations;
  final String recommendations;
  final String status; // 'Pendiente', 'En Curso', 'Finalizada'

  const AcademicVisitModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.companyName,
    required this.companyTutorName,
    required this.career,
    required this.date,
    this.arrivalTime,
    this.departureTime,
    this.activities = '',
    this.observations = '',
    this.recommendations = '',
    this.status = 'Pendiente',
  });

  AcademicVisitModel copyWith({
    String? arrivalTime,
    String? departureTime,
    String? activities,
    String? observations,
    String? recommendations,
    String? status,
  }) {
    return AcademicVisitModel(
      id: id,
      studentId: studentId,
      studentName: studentName,
      companyName: companyName,
      companyTutorName: companyTutorName,
      career: career,
      date: date,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      activities: activities ?? this.activities,
      observations: observations ?? this.observations,
      recommendations: recommendations ?? this.recommendations,
      status: status ?? this.status,
    );
  }
}