import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/rol_usuario_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:bitacoras_app/features/tutores/domain/models/estudiante_asignado_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson accepts float values coming from the Django API', () {
    final json = {
      'id': 7,
      'student': {
        'id': 20,
        'username': 'jhelmy.andy@est.itstena.edu.ec',
        'email': 'jhelmy.andy@est.itstena.edu.ec',
        'first_name': 'Jhelmy',
        'last_name': 'Andy',
        'name': 'Jhelmy Andy',
        'rol': 'estudiante',
      },
      'academic_tutor_id': 1,
      'company_tutor_id': 4,
      'company_tutor_name': 'Edith Agreda',
      'company_tutor_phone': '0995923336',
      'total_hours_required': 96.0,
      'total_hours_completed': 12.0,
      'status': 'En Proceso',
    };

    final model = EstudianteAsignadoModel.fromJson(json);

    expect(model.student.name, 'Jhelmy Andy');
    expect(model.totalHoursRequired, 96);
    expect(model.totalHoursCompleted, 12);
    expect(model.status, 'En Proceso');
  });

  test('frontend hides pending states and uses a non-pending label', () {
    expect(RegistroPracticaModel.normalizeStatus('Pendiente'), 'En curso');
    expect(RegistroPracticaModel.normalizeStatus('Aprobado'), 'Aprobado');
    expect(RegistroPracticaModel.normalizeStatus(false), 'En curso');
    expect(RegistroPracticaModel.normalizeStatus('Desactivado'), 'En curso');
  });
}
