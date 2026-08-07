import 'package:bitacoras_app/shared/exports.dart'; // O tus enums de UserRole

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? company;
  final UserRole role;
  
  // Nuevos campos para detalle y backend Django
  final bool isActive;
  final String? phone;
  final String? cedula;
  final String? careerName;
  final String? periodName;

  const UserModel({
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
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? company,
    UserRole? role,
    bool? isActive,
    String? phone,
    String? cedula,
    String? careerName,
    String? periodName,
  }) {
    return UserModel(
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
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      company: json['company'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.student,
      ),
      isActive: json['is_active'] ?? true,
      phone: json['phone'],
      cedula: json['cedula'],
      careerName: json['career_name'],
      periodName: json['period_name'],
    );
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