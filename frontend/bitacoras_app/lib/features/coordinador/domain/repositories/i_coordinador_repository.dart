abstract class ICoordinadorRepository {
  /// Consulta exclusivamente de lectura para estudiantes.
  Future<List<Map<String, dynamic>>> getEstudiantes();

  /// Consulta exclusivamente de lectura para carreras.
  Future<List<Map<String, dynamic>>> getCarreras();

  /// Consulta exclusivamente de lectura para tutores.
  Future<List<Map<String, dynamic>>> getTutores();
}