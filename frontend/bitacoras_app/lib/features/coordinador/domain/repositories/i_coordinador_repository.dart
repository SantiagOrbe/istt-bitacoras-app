import 'package:bitacoras_app/features/coordinador/coordinador.dart';

abstract class ICoordinadorRepository {
  /// Consulta de lectura para estudiantes de la carrera del coordinador.
  Future<List<CoordinadorEstudianteModel>> getEstudiantes();

  /// Consulta de lectura para el catálogo de carreras.
  Future<List<CoordinadorCarreraModel>> getCarreras();

  /// Consulta de lectura para tutores académicos.
  Future<List<CoordinadorTutorModel>> getTutores();
  Future<CoordinadorDatosModel> getDatosCarrera();
}
