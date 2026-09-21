import 'package:bitacoras_app/features/tutores/domain/models/estudiante_asignado_model.dart';

void main() {
  final data = {
    'id': 7,
    'student': {
      'id': 20,
      'username': 'jhelmy.andy@est.itstena.edu.ec',
      'email': 'jhelmy.andy@est.itstena.edu.ec',
      'first_name': 'Jhelmy',
      'last_name': 'Andy',
      'name': 'Jhelmy Andy',
      'phone': '0992635551',
      'cedula': '1501005043',
      'company': 'Casa admin',
      'company_name': 'Casa admin',
      'career_name': 'Desarrollo De Software',
      'period_name': null,
      'carrera_id': 1,
      'semestre_id': 8,
      'semestre_nombre': 'Segundo',
      'horas_practicas': 96,
      'rol': 'estudiante',
      'estado': true,
      'is_active': true,
    },
    'academic_tutor_id': 1,
    'company_tutor_id': 4,
    'company_tutor_name': 'Edith Agreda',
    'company_tutor_phone': '0995923336',
    'total_hours_required': 96,
    'total_hours_completed': 12.0,
    'status': 'En Proceso',
    'last_activity_description': 'Limpiar muebles.',
    'last_activity_date': '2026-09-19',
    'last_attendance_time': '10:00',
  };

  try {
    final model = EstudianteAsignadoModel.fromJson(data);
    print('parsed: ${model.student.name}, ${model.totalHoursRequired}, ${model.status}');
  } catch (e, st) {
    print('ERROR: $e');
    print(st);
  }
}
