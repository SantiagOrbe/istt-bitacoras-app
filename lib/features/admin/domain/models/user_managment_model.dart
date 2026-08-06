class ManagedUser {
  final String id;
  final String name;
  final String idNumber;
  final String role;
  final bool isActive;

  const ManagedUser({
    required this.id,
    required this.name,
    required this.idNumber,
    required this.role,
    required this.isActive,
  });

  /// Getter útil para avatar o insignias con iniciales
  String get initials {
    final names = name.trim().split(' ');
    if (names.length >= 2 && names[0].isNotEmpty && names[1].isNotEmpty) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names.isNotEmpty && names[0].isNotEmpty ? names[0][0].toUpperCase() : 'U';
  }

  factory ManagedUser.fromJson(Map<String, dynamic> json) {
    return ManagedUser(
      id: json['id'] as String,
      name: json['name'] as String,
      idNumber: json['id_number'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
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

  ManagedUser copyWith({
    String? id,
    String? name,
    String? idNumber,
    String? role,
    bool? isActive,
  }) {
    return ManagedUser(
      id: id ?? this.id,
      name: name ?? this.name,
      idNumber: idNumber ?? this.idNumber,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}