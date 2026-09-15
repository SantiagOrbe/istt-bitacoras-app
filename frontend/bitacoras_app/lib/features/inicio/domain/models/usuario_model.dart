import 'package:bitacoras_app/shared/exports.dart'; // O tus enums de RolUsuarioModel

class UsuarioModel {
  final String id;
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

  const UsuarioModel({
    required this.id,
    required this.name,
    required this.email,
    this.company,
    required this.role,
    this.isActive = true,
    this.phone,
    this.cedula,
    this.careerName,
    this.periodName,
  });

  // Método copyWith fundamental para la lógica del Controller
  UsuarioModel copyWith({
    String? id,
    String? name,
    String? email,
    String? company,
    RolUsuarioModel? role,
    bool? isActive,
    String? phone,
    String? cedula,
    String? careerName,
    String? periodName,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      company: company ?? this.company,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      phone: phone ?? this.phone,
      cedula: cedula ?? this.cedula,
      careerName: careerName ?? this.careerName,
      periodName: periodName ?? this.periodName,
    );
  }

  // Serialización lista para Django REST Framework
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    final profile = json['perfil'] as Map<String, dynamic>?;
    final user = profile?['usuario'] as Map<String, dynamic>? ?? json;
    final roleName = (user['rol'] ?? json['role']) as String? ?? '';
    final fullName = [user['first_name'], user['last_name']]
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .join(' ');

    return UsuarioModel(
      id: user['id']?.toString() ?? '',
      name: (user['name'] as String?) ??
          (fullName.isEmpty ? user['username'] as String? ?? '' : fullName),
      email: user['email'] as String? ?? '',
      company: user['company'] as String?,
      role: _roleFromName(roleName),
      isActive: user['estado'] as bool? ?? user['is_active'] as bool? ?? true,
      phone: user['telefono'] as String? ?? user['phone'] as String?,
      cedula: profile?['cedula'] as String? ?? user['cedula'] as String?,
      careerName: profile?['carrera']?.toString() ?? user['career_name'] as String?,
      periodName: user['period_name'] as String?,
    );
  }

  static RolUsuarioModel _roleFromName(String role) {
    return switch (role.toLowerCase()) {
      'estudiante' || 'student' => RolUsuarioModel.student,
      'docente' || 'teacher' => RolUsuarioModel.teacher,
      'tutor_academico' || 'academictutor' => RolUsuarioModel.academicTutor,
      'tutor_empresarial' || 'companytutor' => RolUsuarioModel.companyTutor,
      'coordinador' || 'coordinator' => RolUsuarioModel.coordinator,
      'responsable_practicas' || 'practicemanager' => RolUsuarioModel.practiceManager,
      'admin' || 'administrador' => RolUsuarioModel.admin,
      _ => RolUsuarioModel.student,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'company': company,
      'role': role.name,
      'is_active': isActive,
      'phone': phone,
      'cedula': cedula,
      'career_name': careerName,
      'period_name': periodName,
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