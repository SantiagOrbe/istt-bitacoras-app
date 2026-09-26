class EmpresaModel {
  final String id;
  final String name;
  final String canton;
  final String address;
  final String phone;
  final String email;
  final double latitude;
  final double longitude;
  final double allowedRadius;
  final bool isActive;

  const EmpresaModel({
    required this.id,
    required this.name,
    this.canton = '',
    required this.address,
    required this.phone,
    required this.email,
    this.latitude = -0.1807,
    this.longitude = -78.4834,
    this.allowedRadius = 50,
    this.isActive = true,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] as String? ?? '',
      canton: json['canton'] as String? ?? '',
      address: json['direccion'] as String? ?? '',
      phone: json['telefono'] as String? ?? '',
      email: json['correo'] as String? ?? '',
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
        'canton': canton,
        'direccion': address,
        'telefono': phone,
        'correo': email,
        'latitud': latitude,
        'longitud': longitude,
        'radio_permitido': allowedRadius,
        'estado': isActive,
      };

  Map<String, dynamic> aJson() => toJson();

  EmpresaModel copyWith({
    String? id,
    String? name,
    String? canton,
    String? address,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
    double? allowedRadius,
    bool? isActive,
  }) {
    return EmpresaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      canton: canton ?? this.canton,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      allowedRadius: allowedRadius ?? this.allowedRadius,
      isActive: isActive ?? this.isActive,
    );
  }

  EmpresaModel copiarCon({
    String? nuevoId,
    String? nombre,
    String? nuevoCanton,
    String? direccion,
    String? telefono,
    String? correo,
    double? latitud,
    double? longitud,
    double? radioPermitido,
    bool? estado,
  }) {
    return EmpresaModel(
      id: nuevoId ?? id,
      name: nombre ?? name,
      canton: nuevoCanton ?? canton,
      address: direccion ?? address,
      phone: telefono ?? phone,
      email: correo ?? email,
      latitude: latitud ?? latitude,
      longitude: longitud ?? longitude,
      allowedRadius: radioPermitido ?? allowedRadius,
      isActive: estado ?? isActive,
    );
  }
}

typedef EmpresaModelo = EmpresaModel;

extension EmpresaModelEspanol on EmpresaModel {
  String get nombre => name;
  String get direccion => address;
  String get telefono => phone;
  String get correo => email;
  String get cantonField => canton;
  double get latitud => latitude;
  double get longitud => longitude;
  double get radioPermitido => allowedRadius;
  bool get estado => isActive;

  EmpresaModel conNombre(String nuevoNombre) => copyWith(name: nuevoNombre);
  EmpresaModel conCanton(String nuevoCanton) => copyWith(canton: nuevoCanton);
  EmpresaModel conDireccion(String nuevaDireccion) =>
      copyWith(address: nuevaDireccion);
  EmpresaModel conTelefono(String nuevoTelefono) =>
      copyWith(phone: nuevoTelefono);
  EmpresaModel conCorreo(String nuevoCorreo) => copyWith(email: nuevoCorreo);
  EmpresaModel conLatitud(double nuevaLatitud) =>
      copyWith(latitude: nuevaLatitud);
  EmpresaModel conLongitud(double nuevaLongitud) =>
      copyWith(longitude: nuevaLongitud);
  EmpresaModel conRadioPermitido(double nuevoRadio) =>
      copyWith(allowedRadius: nuevoRadio);
  EmpresaModel conEstado(bool nuevoEstado) => copyWith(isActive: nuevoEstado);
}
