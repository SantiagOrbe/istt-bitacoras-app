import 'package:bitacoras_app/shared/exports.dart';

/// Modelo principal del usuario autenticado en la aplicación.
///
/// Se conserva la API original para evitar romper el resto del proyecto,
/// pero se añaden alias y métodos en español para la nueva nomenclatura.
class UsuarioModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String? company;
  final RolUsuarioModel role;

  // Nuevos campos para detalle y backend Django
  final bool isActive;
  final String? phone;
  final String? cedula;
  final String? careerName;
  final String? periodName;
  final String? password;
  final String? tutorAcademico;
  final String? tutorEmpresarial;
  final String? cargo;
  final String? companyId;
  final String? carreraId;
  final String? semestreId;
  final String? semestreNombre;
  final String? paraleloId;
  final String? paraleloNombre;
  final int horasPracticas;
  final bool puedeRegistrarPracticas;

  const UsuarioModel({
    required this.id,
    this.username = '',
    required this.name,
    required this.email,
    this.company,
    required this.role,
    this.isActive = true,
    this.phone,
    this.cedula,
    this.careerName,
    this.periodName,
    this.password,
    this.tutorAcademico,
    this.tutorEmpresarial,
    this.cargo,
    this.companyId,
    this.carreraId,
    this.semestreId,
    this.semestreNombre,
    this.paraleloId,
    this.paraleloNombre,
    this.horasPracticas = 0,
    this.puedeRegistrarPracticas = false,
  });

  // Método de copia fundamental para la lógica del controlador.
  UsuarioModel copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? company,
    RolUsuarioModel? role,
    bool? isActive,
    String? phone,
    String? cedula,
    String? careerName,
    String? periodName,
    String? password,
    String? tutorAcademico,
    String? tutorEmpresarial,
    String? cargo,
    String? companyId,
    String? carreraId,
    String? semestreId,
    String? semestreNombre,
    String? paraleloId,
    String? paraleloNombre,
    int? horasPracticas,
    bool? puedeRegistrarPracticas,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      company: company ?? this.company,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      phone: phone ?? this.phone,
      cedula: cedula ?? this.cedula,
      careerName: careerName ?? this.careerName,
      periodName: periodName ?? this.periodName,
      password: password ?? this.password,
      tutorAcademico: tutorAcademico ?? this.tutorAcademico,
      tutorEmpresarial: tutorEmpresarial ?? this.tutorEmpresarial,
      cargo: cargo ?? this.cargo,
      companyId: companyId ?? this.companyId,
      carreraId: carreraId ?? this.carreraId,
      semestreId: semestreId ?? this.semestreId,
      semestreNombre: semestreNombre ?? this.semestreNombre,
      paraleloId: paraleloId ?? this.paraleloId,
      paraleloNombre: paraleloNombre ?? this.paraleloNombre,
      horasPracticas: horasPracticas ?? this.horasPracticas,
      puedeRegistrarPracticas:
          puedeRegistrarPracticas ?? this.puedeRegistrarPracticas,
    );
  }

  /// Alias en español para la operación de copia.
  UsuarioModel copiarCon({
    String? id,
    String? username,
    String? name,
    String? email,
    String? company,
    RolUsuarioModel? role,
    bool? isActive,
    String? phone,
    String? cedula,
    String? careerName,
    String? periodName,
    String? password,
    String? tutorAcademico,
    String? tutorEmpresarial,
    String? cargo,
    String? companyId,
    String? carreraId,
    String? semestreId,
    String? semestreNombre,
    String? paraleloId,
    String? paraleloNombre,
    int? horasPracticas,
    bool? puedeRegistrarPracticas,
  }) {
    return copyWith(
      id: id,
      username: username,
      name: name,
      email: email,
      company: company,
      role: role,
      isActive: isActive,
      phone: phone,
      cedula: cedula,
      careerName: careerName,
      periodName: periodName,
      password: password,
      tutorAcademico: tutorAcademico,
      tutorEmpresarial: tutorEmpresarial,
      cargo: cargo,
      companyId: companyId,
      carreraId: carreraId,
      semestreId: semestreId,
      semestreNombre: semestreNombre,
      paraleloId: paraleloId,
      paraleloNombre: paraleloNombre,
      horasPracticas: horasPracticas,
      puedeRegistrarPracticas: puedeRegistrarPracticas,
    );
  }

  /// Serialización lista para Django REST Framework.
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    final perfil = json['perfil'] as Map<String, dynamic>?;
    final usuario = perfil?['usuario'] as Map<String, dynamic>? ?? json;
    final nombreRol = (usuario['rol'] ?? json['role']) as String? ?? '';
    final rol = _roleFromName(nombreRol);
    final nombreCarrera = usuario['career_name']?.toString() ??
        perfil?['career_name']?.toString() ??
        (perfil?['carrera'] is Map<String, dynamic>
            ? (perfil?['carrera'] as Map<String, dynamic>)['nombre']?.toString()
            : null);
    final nombreCompleto = [
      usuario['first_name'],
      usuario['last_name'],
    ].whereType<String>().where((valor) => valor.trim().isNotEmpty).join(' ');

    final horasRequeridas =
        (perfil?['horas_practicas'] ?? usuario['horas_practicas'] ?? 0) as num? ?? 0;

    return UsuarioModel(
      id: usuario['id']?.toString() ?? '',
      username: usuario['username']?.toString() ?? '',
      name: (usuario['name'] as String?) ??
          (nombreCompleto.isEmpty ? usuario['username'] as String? ?? '' : nombreCompleto),
      email: usuario['email'] as String? ?? '',
      company: (usuario['company_name'] ?? usuario['company'])?.toString(),
      role: rol,
      isActive: usuario['estado'] as bool? ?? usuario['is_active'] as bool? ?? true,
      phone: usuario['telefono']?.toString() ?? usuario['phone']?.toString(),
      cedula: perfil?['cedula']?.toString() ?? usuario['cedula']?.toString(),
      careerName: nombreCarrera,
      periodName: usuario['period_name'] as String?,
      password: null,
      tutorAcademico: perfil?['tutor_academico']?.toString(),
      tutorEmpresarial: perfil?['tutor_empresarial']?.toString(),
      cargo: usuario['cargo']?.toString(),
      companyId: (usuario['empresa_id'] ?? usuario['empresa'])?.toString(),
      carreraId: usuario['carrera_id']?.toString(),
      semestreId: (perfil?['semestre_id'] ?? perfil?['semestre'] ?? usuario['semestre_id'] ?? usuario['semestre'])?.toString(),
      semestreNombre: (perfil?['semestre_nombre'] ?? usuario['semestre_nombre'])?.toString(),
      paraleloId: (perfil?['paralelo_id'] ?? perfil?['paralelo'] ?? usuario['paralelo_id'] ?? usuario['paralelo'])?.toString(),
      paraleloNombre: (perfil?['paralelo_nombre'] ?? usuario['paralelo_nombre'])?.toString(),
      horasPracticas: horasRequeridas.toInt(),
      puedeRegistrarPracticas: (
            perfil?['puede_registrar_practicas'] ??
                usuario['puede_registrar_practicas'] ??
                false
          ) as bool? ?? false,
    );
  }

  /// Alias en español para la fábrica de deserialización.
  factory UsuarioModel.desdeJson(Map<String, dynamic> json) =>
      UsuarioModel.fromJson(json);

  static RolUsuarioModel _roleFromName(String role) {
    return switch (role.toLowerCase()) {
      'estudiante' || 'student' => RolUsuarioModel.student,
      'tutor_academico' || 'academictutor' => RolUsuarioModel.academicTutor,
      'tutor_empresarial' || 'companytutor' => RolUsuarioModel.companyTutor,
      'coordinador' || 'coordinator' => RolUsuarioModel.coordinator,
      'responsable_practicas' || 'practicemanager' =>
        RolUsuarioModel.practiceManager,
      'admin' || 'administrador' => RolUsuarioModel.admin,
      _ => RolUsuarioModel.student,
    };
  }

  /// Alias en español para la conversión de rol.
  static RolUsuarioModel rolDesdeNombre(String rol) => _roleFromName(rol);

  Map<String, dynamic> toJson() {
    final nombres = name.trim().split(RegExp(r'\s+'));
    return {
      'email': email,
      'first_name': nombres.first,
      'last_name': nombres.length > 1 ? nombres.sublist(1).join(' ') : '',
      'telefono': phone ?? '',
      'rol': role.apiValue,
      'estado': isActive,
      'is_active': isActive,
      if (cedula != null && cedula!.isNotEmpty) 'cedula': cedula,
      if (cargo != null && cargo!.isNotEmpty) 'cargo': cargo,
      if (companyId != null && companyId!.isNotEmpty)
        'empresa_id': int.tryParse(companyId!) ?? companyId,
      if (carreraId != null && carreraId!.isNotEmpty)
        'carrera_id': int.tryParse(carreraId!) ?? carreraId,
      if (password != null && password!.isNotEmpty) 'password': password,
    };
  }

  /// Alias en español para serialización.
  Map<String, dynamic> aJson() => toJson();

  String get initials {
    if (name.trim().isEmpty) return 'U';

    final partes = name.trim().split(RegExp(r'\s+'));
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return partes[0][0].toUpperCase();
  }

  /// Alias en español para iniciales.
  String get iniciales => initials;
}

/// Alias en español para mantener compatibilidad con la nomenclatura nueva.
typedef UsuarioModelo = UsuarioModel;
