class UbicacionEmpresaModel {
  final String name;
  final double latitude;
  final double longitude;
  final double allowedRadiusMeters;

  const UbicacionEmpresaModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.allowedRadiusMeters = 200.0,
  });

  String get nombre => name;
  double get latitud => latitude;
  double get longitud => longitude;
  double get radioPermitidoMetros => allowedRadiusMeters;
  double get radioPermitido => allowedRadiusMeters;

  factory UbicacionEmpresaModel.fromJson(Map<String, dynamic> json) {
    return UbicacionEmpresaModel(
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      allowedRadiusMeters:
          (json['allowed_radius_meters'] as num?)?.toDouble() ?? 200.0,
    );
  }

  factory UbicacionEmpresaModel.desdeJson(Map<String, dynamic> json) {
    return UbicacionEmpresaModel.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'allowed_radius_meters': allowedRadiusMeters,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  UbicacionEmpresaModel copyWith({
    String? name,
    double? latitude,
    double? longitude,
    double? allowedRadiusMeters,
  }) {
    return UbicacionEmpresaModel(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      allowedRadiusMeters: allowedRadiusMeters ?? this.allowedRadiusMeters,
    );
  }

  UbicacionEmpresaModel copiarCon({
    String? name,
    double? latitude,
    double? longitude,
    double? allowedRadiusMeters,
  }) {
    return copyWith(
      name: name,
      latitude: latitude,
      longitude: longitude,
      allowedRadiusMeters: allowedRadiusMeters,
    );
  }
}

typedef UbicacionEmpresaModelo = UbicacionEmpresaModel;
