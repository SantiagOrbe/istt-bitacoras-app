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
}
