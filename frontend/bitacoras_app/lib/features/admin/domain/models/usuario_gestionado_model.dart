class UsuarioGestionadoModel {
  final String id;
  final String name;
  final String idNumber;
  final String role;
  final bool isActive;

  const UsuarioGestionadoModel({
    required this.id,
    required this.name,
    required this.idNumber,
    required this.role,
    required this.isActive,
  });

  String get nombre => name;
  String get numeroIdentificacion => idNumber;
  String get rol => role;
  bool get activo => isActive;

  /// Getter útil para avatar o insignias con iniciales.
  String get initials => iniciales;

  String get iniciales {
    final names = name.trim().split(' ');
    if (names.length >= 2 && names[0].isNotEmpty && names[1].isNotEmpty) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names.isNotEmpty && names[0].isNotEmpty
        ? names[0][0].toUpperCase()
        : 'U';
  }

  factory UsuarioGestionadoModel.fromJson(Map<String, dynamic> json) {
    return UsuarioGestionadoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      idNumber: json['id_number'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  factory UsuarioGestionadoModel.desdeJson(Map<String, dynamic> json) {
    return UsuarioGestionadoModel.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'id_number': idNumber,
      'role': role,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  UsuarioGestionadoModel copyWith({
    String? id,
    String? name,
    String? idNumber,
    String? role,
    bool? isActive,
  }) {
    return UsuarioGestionadoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      idNumber: idNumber ?? this.idNumber,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  UsuarioGestionadoModel copiarCon({
    String? id,
    String? name,
    String? idNumber,
    String? role,
    bool? isActive,
  }) {
    return copyWith(
      id: id,
      name: name,
      idNumber: idNumber,
      role: role,
      isActive: isActive,
    );
  }
}

/// Alias de compatibilidad para uso en español en el código del front.
typedef UsuarioGestionadoModelo = UsuarioGestionadoModel;
