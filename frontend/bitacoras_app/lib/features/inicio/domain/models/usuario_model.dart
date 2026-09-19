import 'package:bitacoras_app/shared/exports.dart'; // O tus enums de RolUsuarioModel

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
  });

  // Método copyWith fundamental para la lógica del Controller
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
    );
  }

  // Serialización lista para Django REST Framework
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    final profile = json['perfil'] as Map<String, dynamic>?;
    final user = profile?['usuario'] as Map<String, dynamic>? ?? json;
    final roleName = (user['rol'] ?? json['role']) as String? ?? '';
    final role = _roleFromName(roleName);
    final careerName = user['career_name']?.toString() ??
      profile?['career_name']?.toString() ??
      (profile?['carrera'] is Map<String, dynamic>
        ? (profile?['carrera'] as Map<String, dynamic>)['nombre']?.toString()
        : null);
    final fullName = [
      user['first_name'],
      user['last_name'],
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' ');

    return UsuarioModel(
      id: user['id']?.toString() ?? '',
      username: user['username']?.toString() ?? '',
      name:
          (user['name'] as String?) ??
          (fullName.isEmpty ? user['username'] as String? ?? '' : fullName),
      email: user['email'] as String? ?? '',
      company: (user['company_name'] ?? user['company'])?.toString(),
      role: role,
      isActive: user['estado'] as bool? ?? user['is_active'] as bool? ?? true,
      phone: user['telefono']?.toString() ?? user['phone']?.toString(),
      cedula: profile?['cedula']?.toString() ?? user['cedula']?.toString(),
      careerName: careerName,
      periodName: user['period_name'] as String?,
      password: null,
      tutorAcademico: profile?['tutor_academico']?.toString(),
      tutorEmpresarial: profile?['tutor_empresarial']?.toString(),
      cargo: user['cargo']?.toString(),
      companyId: (user['empresa_id'] ?? user['empresa'])?.toString(),
      carreraId: user['carrera_id']?.toString(),
    );
  }

  static RolUsuarioModel _roleFromName(String role) {
    return switch (role.toLowerCase()) {
      'estudiante' || 'student' => RolUsuarioModel.student,
      'docente' || 'teacher' => RolUsuarioModel.teacher,
      'tutor_academico' || 'academictutor' => RolUsuarioModel.academicTutor,
      'tutor_empresarial' || 'companytutor' => RolUsuarioModel.companyTutor,
      'coordinador' || 'coordinator' => RolUsuarioModel.coordinator,
      'responsable_practicas' ||
      'practicemanager' => RolUsuarioModel.practiceManager,
      'admin' || 'administrador' => RolUsuarioModel.admin,
      _ => RolUsuarioModel.student,
    };
  }

  Map<String, dynamic> toJson() {
    final names = name.trim().split(RegExp(r'\s+'));
    return {
      'email': email,
      'first_name': names.first,
      'last_name': names.length > 1 ? names.sublist(1).join(' ') : '',
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

  String get initials {
    if (name.trim().isEmpty) return 'U';

    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
