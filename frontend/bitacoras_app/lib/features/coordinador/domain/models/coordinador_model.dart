class CoordinadorModel {
  final String id;
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final String cedula;
  final String rol;
  final bool estado;

  const CoordinadorModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.telefono,
    required this.cedula,
    this.rol = 'COORDINADOR',
    this.estado = true,
  });

  String get nombreCompleto => '$nombre $apellido';

  factory CoordinadorModel.fromJson(Map<String, dynamic> json) {
    return CoordinadorModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      correo: json['correo'] as String,
      telefono: json['telefono'] as String,
      cedula: json['cedula'] as String,
      rol: json['rol'] as String? ?? 'COORDINADOR',
      estado: json['estado'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'telefono': telefono,
      'cedula': cedula,
      'rol': rol,
      'estado': estado,
    };
  }
}