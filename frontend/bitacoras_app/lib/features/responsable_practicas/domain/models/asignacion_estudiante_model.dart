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
  final String? semesterId;
  final String? parallelId;

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
    this.semesterId,
    this.parallelId,
  });

  AsignacionEstudianteModel copyWith({
    String? nuevoId,
    String? nuevoStudentId,
    String? nuevoStudentName,
    String? nuevaStudentIdentification,
    String? nuevaCareer,
    String? nuevoAcademicTutorId,
    String? nuevoAcademicTutorName,
    String? nuevoCompanyTutorId,
    String? nuevoCompanyTutorName,
    String? nuevoCompanyId,
    String? nuevoCompanyName,
    bool? nuevoIsAssigned,
  }) {
    return AsignacionEstudianteModel(
      id: nuevoId ?? id,
      studentId: nuevoStudentId ?? studentId,
      studentName: nuevoStudentName ?? studentName,
      studentIdentification: nuevaStudentIdentification ?? studentIdentification,
      career: nuevaCareer ?? career,
      academicTutorId: nuevoAcademicTutorId ?? academicTutorId,
      academicTutorName: nuevoAcademicTutorName ?? academicTutorName,
      companyTutorId: nuevoCompanyTutorId ?? companyTutorId,
      companyTutorName: nuevoCompanyTutorName ?? companyTutorName,
      companyId: nuevoCompanyId ?? companyId,
      companyName: nuevoCompanyName ?? companyName,
      isAssigned: nuevoIsAssigned ?? isAssigned,
      semesterId: semesterId,
      parallelId: parallelId,
    );
  }

  /// Alias en español para la copia del modelo.
  AsignacionEstudianteModel copiarCon({
    String? nuevoId,
    String? nuevoEstudianteId,
    String? nuevoNombreEstudiante,
    String? nuevaIdentificacionEstudiante,
    String? nuevaCarrera,
    String? nuevoTutorAcademicoId,
    String? nuevoNombreTutorAcademico,
    String? nuevoTutorEmpresarialId,
    String? nuevoNombreTutorEmpresarial,
    String? nuevaEmpresaId,
    String? nuevoNombreEmpresa,
    bool? nuevoEstaAsignado,
  }) {
    return AsignacionEstudianteModel(
      id: nuevoId ?? id,
      studentId: nuevoEstudianteId ?? studentId,
      studentName: nuevoNombreEstudiante ?? studentName,
      studentIdentification: nuevaIdentificacionEstudiante ?? studentIdentification,
      career: nuevaCarrera ?? career,
      academicTutorId: nuevoTutorAcademicoId ?? academicTutorId,
      academicTutorName: nuevoNombreTutorAcademico ?? academicTutorName,
      companyTutorId: nuevoTutorEmpresarialId ?? companyTutorId,
      companyTutorName: nuevoNombreTutorEmpresarial ?? companyTutorName,
      companyId: nuevaEmpresaId ?? companyId,
      companyName: nuevoNombreEmpresa ?? companyName,
      isAssigned: nuevoEstaAsignado ?? isAssigned,
      semesterId: semesterId,
      parallelId: parallelId,
    );
  }

  /// Alias en español para propiedades de acceso.
  String get estudianteId => studentId;
  String get nombreEstudiante => studentName;
  String get identificacionEstudiante => studentIdentification;
  String get carrera => career;
  String? get tutorAcademicoId => academicTutorId;
  String? get nombreTutorAcademico => academicTutorName;
  String? get tutorEmpresarialId => companyTutorId;
  String? get nombreTutorEmpresarial => companyTutorName;
  String? get empresaId => companyId;
  String? get nombreEmpresa => companyName;
  bool get estaAsignado => isAssigned;
  String? get semestreId => semesterId;
  String? get paraleloId => parallelId;
}

typedef AsignacionEstudiante = AsignacionEstudianteModel;
