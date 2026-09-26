class EmpresaModel {
  final String id;
  final String name;
  final String ruc;
  final String canton;
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
    this.canton = '',
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
      canton: json['canton'] as String? ?? '',
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

  factory EmpresaModel.desdeJson(Map<String, dynamic> json) =>
      EmpresaModel.fromJson(json);

  Map<String, dynamic> toJson() => {
    'nombre': name,
    'ruc': ruc,
    'canton': canton,
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

  Map<String, dynamic> aJson() => toJson();

  EmpresaModel copyWith({
    String? nuevoId,
    String? nuevoName,
    String? nuevoRuc,
    String? nuevoCanton,
    String? nuevaAddress,
    String? nuevoPhone,
    String? nuevoEmail,
    String? nuevoLegalRepresentative,
    String? nuevoAgreementNumber,
    double? nuevaLatitude,
    double? nuevaLongitude,
    double? nuevoAllowedRadius,
    bool? nuevoIsActive,
  }) {
    return EmpresaModel(
      id: nuevoId ?? id,
      name: nuevoName ?? name,
      ruc: nuevoRuc ?? ruc,
      canton: nuevoCanton ?? canton,
      address: nuevaAddress ?? address,
      phone: nuevoPhone ?? phone,
      email: nuevoEmail ?? email,
      legalRepresentative: nuevoLegalRepresentative ?? legalRepresentative,
      agreementNumber: nuevoAgreementNumber ?? agreementNumber,
      latitude: nuevaLatitude ?? latitude,
      longitude: nuevaLongitude ?? longitude,
      allowedRadius: nuevoAllowedRadius ?? allowedRadius,
      isActive: nuevoIsActive ?? isActive,
    );
  }

  /// Alias en español para la copia del modelo.
  EmpresaModel copiarCon({
    String? nuevoId,
    String? nuevoNombre,
    String? nuevoRuc,
    String? nuevaDireccion,
    String? nuevoTelefono,
    String? nuevoCorreo,
    String? nuevoRepresentanteLegal,
    String? nuevoNumeroConvenio,
    double? nuevaLatitud,
    double? nuevaLongitud,
    double? nuevoRadioPermitido,
    bool? nuevoEstado,
  }) {
    return EmpresaModel(
      id: nuevoId ?? id,
      name: nuevoNombre ?? name,
      ruc: nuevoRuc ?? ruc,
      address: nuevaDireccion ?? address,
      phone: nuevoTelefono ?? phone,
      email: nuevoCorreo ?? email,
      legalRepresentative: nuevoRepresentanteLegal ?? legalRepresentative,
      agreementNumber: nuevoNumeroConvenio ?? agreementNumber,
      latitude: nuevaLatitud ?? latitude,
      longitude: nuevaLongitud ?? longitude,
      allowedRadius: nuevoRadioPermitido ?? allowedRadius,
      isActive: nuevoEstado ?? isActive,
    );
  }

  /// Alias en español para propiedades de acceso.
  String get nombre => name;
  String get documentoRuc => ruc;
  String get direccion => address;
  String get telefonoEmpresa => phone;
  String get correoEmpresa => email;
  String get representanteLegal => legalRepresentative;
  String get numeroConvenio => agreementNumber;
  double get latitud => latitude;
  double get longitud => longitude;
  double get radioPermitido => allowedRadius;
  bool get estaActivo => isActive;
}

typedef Empresa = EmpresaModel;
