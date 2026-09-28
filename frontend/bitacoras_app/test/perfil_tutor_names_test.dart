import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:bitacoras_app/features/perfiles/domain/models/perfil_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('student profile prefers tutor names over relationship IDs', () {
    final user = UsuarioModel.fromJson({
      'perfil': {
        'tutor_academico': 17,
        'tutor_academico_nombre': 'María Pérez',
        'tutor_empresarial': 23,
        'tutor_empresarial_nombre': 'Luis Gómez',
        'usuario': {
          'id': 4,
          'username': 'estudiante',
          'first_name': 'Estudiante',
          'last_name': 'Prueba',
          'email': 'estudiante@est.itstena.edu.ec',
          'rol': 'estudiante',
        },
      },
    });

    final profile = PerfilModel.fromUser(user);

    expect(profile.tutorAcademico, 'María Pérez');
    expect(profile.tutorEmpresarial, 'Luis Gómez');
  });
}