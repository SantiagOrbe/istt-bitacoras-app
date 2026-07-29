class StudentProfileModel {
  // Datos heredados de USUARIO
  final String id;
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final String rol;
  final String estado;

  // Atributos de ESTUDIANTE
  final String cedula;
  final String matricula;

  // Tutores asignados
  final String tutorAcademico;
  final String tutorEmpresarial;

  StudentProfileModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.telefono,
    required this.rol,
    required this.estado,
    required this.cedula,
    required this.matricula,
    required this.tutorAcademico,
    required this.tutorEmpresarial,
  });

  String get fullName => '$nombre $apellido';

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      rol: json['rol'] ?? 'ESTUDIANTE',
      estado: json['estado'] ?? 'ACTIVO',
      cedula: json['cedula'] ?? '',
      matricula: json['matricula'] ?? '',
      tutorAcademico: json['tutor_academico'] ?? 'Sin asignar',
      tutorEmpresarial: json['tutor_empresarial'] ?? 'Sin asignar',
    );
  }
}