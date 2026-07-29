import 'user_role.dart';

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String company;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.company,
    required this.role,
  });

  // Factory para deserializar desde la API REST de Django
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      fullName: json['full_name'] ?? json['nombre_completo'] ?? '',
      email: json['email'] ?? json['correo'] ?? '',
      company: json['company'] ?? json['empresa'] ?? '',
      role: _parseRole(json['role'] ?? json['rol']),
    );
  }

  // Método opcional para enviar de vuelta al backend si fuese necesario
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'company': company,
      'role': role.name,
    };
  }

  // Helper para mapear el String de la API al enum UserRole
  static UserRole _parseRole(String? roleStr) {
    if (roleStr == null) return UserRole.student;
    
    switch (roleStr.toLowerCase()) {
      case 'student':
      case 'estudiante':
        return UserRole.student;
      case 'tutor':
      case 'tutor_academico':
        return UserRole.academicTutor;
      case 'admin':
      case 'coordinador':
        return UserRole.admin;
      default:
        return UserRole.student;
    }
  }
}