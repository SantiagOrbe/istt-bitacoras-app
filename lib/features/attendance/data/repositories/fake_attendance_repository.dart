class CompanyLocation {
  final String name;
  final double latitude;
  final double longitude;
  final double allowedRadiusMeters;

  const CompanyLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.allowedRadiusMeters = 200.0, // Radio en metros
  });
}

class FakeAttendanceRepository {
  // Ubicación asignada fake (ej. Municipio de Tena)
  static const CompanyLocation assignedCompany = CompanyLocation(
    name: 'Municipio Tena',
    latitude: -0.9938, // Coordenadas de Tena, Napo
    longitude: -77.8128,
    allowedRadiusMeters: 200.0,
  );

  // Simulación de envío a servidor
  Future<bool> registerAttendance({
    required String type, // 'ENTRY' o 'EXIT'
    required double latitude,
    required double longitude,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Éxito
  }
}