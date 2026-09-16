class EmpresaModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final double allowedRadius;
  final bool isActive;

  const EmpresaModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.allowedRadius,
    this.isActive = true,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] as String? ?? '',
      address: json['direccion'] as String? ?? '',
      phone: json['telefono'] as String? ?? '',
      email: json['correo'] as String? ?? '',
      allowedRadius: (json['radio_permitido'] as num?)?.toDouble() ?? 0,
      isActive: json['estado'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre': name,
    'direccion': address,
    'telefono': phone,
    'correo': email,
    'radio_permitido': allowedRadius,
    'estado': isActive,
  };

  EmpresaModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    double? allowedRadius,
    bool? isActive,
  }) {
    return EmpresaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      allowedRadius: allowedRadius ?? this.allowedRadius,
      isActive: isActive ?? this.isActive,
    );
  }
}
