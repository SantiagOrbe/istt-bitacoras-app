class EmpresaModel {
  final String id;
  final String name;
  final String ruc;
  final String address;
  final String phone;
  final String email;
  final String legalRepresentative;
  final String agreementNumber; // Número de convenio institucional
  final double latitude;
  final double longitude;
  final double allowedRadius;
  final bool isActive;

  const EmpresaModel({
    required this.id,
    required this.name,
    required this.ruc,
    required this.address,
    required this.phone,
    required this.email,
    required this.legalRepresentative,
    required this.agreementNumber,
    this.latitude = -0.1807,
    this.longitude = -78.4834,
    this.allowedRadius = 50,
    this.isActive = true,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] as String? ?? '',
      ruc: json['ruc'] as String? ?? '',
      address: json['direccion'] as String? ?? '',
      phone: json['telefono'] as String? ?? '',
      email: json['correo'] as String? ?? '',
      legalRepresentative: json['representante_legal'] as String? ?? '',
      agreementNumber: json['numero_convenio'] as String? ?? '',
      latitude: (json['latitud'] as num?)?.toDouble() ?? -0.1807,
      longitude: (json['longitud'] as num?)?.toDouble() ?? -78.4834,
      allowedRadius: (json['radio_permitido'] as num?)?.toDouble() ?? 50,
      isActive: json['estado'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre': name,
    'ruc': ruc,
    'direccion': address,
    'telefono': phone,
    'correo': email,
    'representante_legal': legalRepresentative,
    'numero_convenio': agreementNumber,
    'latitud': latitude,
    'longitud': longitude,
    'radio_permitido': allowedRadius,
    'estado': isActive,
  };

  EmpresaModel copyWith({
    String? id,
    String? name,
    String? ruc,
    String? address,
    String? phone,
    String? email,
    String? legalRepresentative,
    String? agreementNumber,
    double? latitude,
    double? longitude,
    double? allowedRadius,
    bool? isActive,
  }) {
    return EmpresaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ruc: ruc ?? this.ruc,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      legalRepresentative: legalRepresentative ?? this.legalRepresentative,
      agreementNumber: agreementNumber ?? this.agreementNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      allowedRadius: allowedRadius ?? this.allowedRadius,
      isActive: isActive ?? this.isActive,
    );
  }
}