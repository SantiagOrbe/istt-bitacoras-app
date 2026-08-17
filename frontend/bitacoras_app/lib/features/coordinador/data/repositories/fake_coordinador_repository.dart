import '../../domain/repositories/i_coordinador_repository.dart';

class FakeCoordinadorRepository implements ICoordinadorRepository {
  @override
  Future<List<Map<String, dynamic>>> getEstudiantes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {'id': '1', 'nombre': 'Santiago Orbe', 'carrera': 'Desarrollo de Software', 'tutor': 'Ing. Fernando Pérez'},
      {'id': '2', 'nombre': 'Andres Orbe', 'carrera': 'Veterinaria', 'tutor': 'Ing. Patricia Gómez'},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getCarreras() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {'id': '1', 'nombre': 'Desarrollo de Software', 'codigo': 'DS-01', 'modalidad': 'Presencial'},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getTutores() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {'id': '1', 'nombre': 'Ing. Fernando Pérez', 'correo': 'fperez@isttena.edu.ec'},
      {'id': '2', 'nombre': 'Ing. Patricia Gómez', 'correo': 'pgomez@isttena.edu.ec'},
    ];
  }
}