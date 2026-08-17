import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/rol_usuario_model.dart';
import '../../../inicio/domain/models/usuario_model.dart';
import '../../domain/models/visita_academica_model.dart';
import '../../domain/models/estudiante_asignado_model.dart';
import '../../domain/repositories/i_tutor_repository.dart';

class FakeTutorRepository implements ITutorRepository {
  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  final List<EstudianteAsignadoModel> _mockAssignedStudents = [
    const EstudianteAsignadoModel(
      student: UsuarioModel(
        id: '1',
        name: 'Santiago Orbe',
        email: 'santiago.orbe@est.itstena.edu.ec',
        phone: '0987654321',
        cedula: '1500123456',
        role: RolUsuarioModel.student,
        company: 'Tech Solutions Tena',
        careerName: 'Desarrollo de Software',
        periodName: 'Mayo 2026 - Octubre 2026',
      ),
      academicTutorId: '3',
      companyTutorId: '4',
      companyTutorName: 'Ing. Carlos Ruiz',
      companyTutorPhone: '0991234567',
      totalHoursRequired: 240,
      totalHoursCompleted: 140,
      status: 'En Proceso',
      lastActivityDescription: 'Integración de endpoints REST en Django y corrección de bugs en UI.',
      lastActivityDate: '06/08/2026',
      lastAttendanceTime: '08:00 AM - 01:00 PM',
    ),
  ];

  final List<RegistroPracticaModel> _mockLogs = [
    const RegistroPracticaModel(
      id: 'log_1',
      studentId: '1',
      studentName: 'Santiago Orbe',
      companyName: 'Tech Solutions Tena',
      date: '2026-08-05',
      entryTime: '08:00 AM',
      exitTime: '12:00 PM',
      activityDescription: 'Configuración e integración de endpoints en Django REST framework.',
      status: 'Aprobado',
    ),
    const RegistroPracticaModel(
      id: 'log_2',
      studentId: '1',
      studentName: 'Santiago Orbe',
      companyName: 'Tech Solutions Tena',
      date: '2026-08-06',
      entryTime: '08:15 AM',
      exitTime: '01:00 PM',
      activityDescription: 'Diseño de pantallas responsive y refactorización modular en Flutter.',
      status: 'Pendiente',
    ),
  ];

  final List<VisitaAcademicaModel> _mockVisits = [];

  @override
  Future<List<EstudianteAsignadoModel>> getAssignedStudents(String tutorId, {required bool isAcademic}) async {
    await _delay();
    return _mockAssignedStudents.where((item) {
      return isAcademic ? item.academicTutorId == tutorId : item.companyTutorId == tutorId;
    }).toList();
  }

  @override
  Future<List<RegistroPracticaModel>> getStudentLogs(String studentId) async {
    await _delay();
    return _mockLogs.where((log) => log.studentId == studentId).toList();
  }

  @override
  Future<bool> saveAcademicVisit(VisitaAcademicaModel visit) async {
    await _delay();
    _mockVisits.add(visit);
    return true;
  }

  @override
  Future<List<VisitaAcademicaModel>> getAcademicVisits(String tutorId) async {
    await _delay();
    return _mockVisits;
  }
}