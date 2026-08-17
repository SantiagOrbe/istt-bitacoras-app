class AsignacionEstudianteModel {
  final String id;
  final String studentId;
  final String studentName;
  final String studentIdentification; // Cédula o código de estudiante
  final String career;
  final String? academicTutorId;
  final String? academicTutorName;
  final String? companyTutorId;
  final String? companyTutorName;
  final String? companyId;
  final String? companyName;
  final bool isAssigned;

  const AsignacionEstudianteModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentIdentification,
    required this.career,
    this.academicTutorId,
    this.academicTutorName,
    this.companyTutorId,
    this.companyTutorName,
    this.companyId,
    this.companyName,
    this.isAssigned = false,
  });

  AsignacionEstudianteModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? studentIdentification,
    String? career,
    String? academicTutorId,
    String? academicTutorName,
    String? companyTutorId,
    String? companyTutorName,
    String? companyId,
    String? companyName,
    bool? isAssigned,
  }) {
    return AsignacionEstudianteModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentIdentification: studentIdentification ?? this.studentIdentification,
      career: career ?? this.career,
      academicTutorId: academicTutorId ?? this.academicTutorId,
      academicTutorName: academicTutorName ?? this.academicTutorName,
      companyTutorId: companyTutorId ?? this.companyTutorId,
      companyTutorName: companyTutorName ?? this.companyTutorName,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      isAssigned: isAssigned ?? this.isAssigned,
    );
  }
}