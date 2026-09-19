import 'package:bitacoras_app/features/estudiantes/data/services/reporte_practica_pdf_service.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';
import 'package:bitacoras_app/features/estudiantes/domain/repositories/i_asistencia_repository.dart';
import 'package:bitacoras_app/features/estudiantes/presentation/controllers/reportes_controller.dart';
import 'package:bitacoras_app/features/inicio/domain/models/rol_usuario_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockAsistenciaRepository implements IAsistenciaRepository {
  @override
  Future<UbicacionEmpresaModel> getAssignedCompanyLocation() async => const UbicacionEmpresaModel(
        name: 'Empresa Demo',
        latitude: 0,
        longitude: 0,
      );

  @override
  Future<RegistroAsistenciaModel?> getCurrentRecord() async => null;

  @override
  Future<RegistroAsistenciaModel?> getTodayRecord() async => null;

  @override
  Future<List<RegistroAsistenciaModel>> getAttendanceHistory() async => [
        RegistroAsistenciaModel(
          id: '1',
          date: '2026-09-01',
          entryTime: '08:00',
          exitTime: '10:30',
          status: 'Completado',
          activities: [
            {'descripcion': 'Revisión de inventario'},
            {'descripcion': 'Atención de clientes'},
          ],
        ),
      ];

  @override
  Future<Map<String, dynamic>> getStudentPracticeProgress() async => {
        'horas_acumuladas': 20,
        'horas_requeridas': 120,
      };

  @override
  Future<bool> registerAttendance({
    required String type,
    required double latitude,
    required double longitude,
  }) async => true;
}

void main() {
  test('genera un PDF con los datos del estudiante y las bitacoras', () async {
    final user = UsuarioModel(
      id: '1',
      name: 'Ana López',
      email: 'ana@correo.com',
      role: RolUsuarioModel.student,
      company: 'Empresa Demo',
      phone: '0999999999',
      cedula: '1500000000',
      careerName: 'Software',
      periodName: '2025 - 2026',
      tutorAcademico: 'MSc. Pedro Cueva',
      tutorEmpresarial: 'Ing. Laura Torres',
      semestreNombre: 'Segundo',
      horasPracticas: 120,
    );

    final history = [
      RegistroAsistenciaModel(
        id: '1',
        date: '2026-09-01',
        entryTime: '08:00',
        exitTime: '10:30',
        status: 'Completado',
        activities: [
          {'descripcion': 'Revisión de inventario'},
          {'descripcion': 'Atención de clientes'},
        ],
      ),
    ];

    final bytes = await ReportePracticaPdfService.generate(user: user, history: history);

    expect(bytes, isNotEmpty);
    expect(bytes.length, greaterThanOrEqualTo(2000));
  });

  test('la generación del PDF devuelve un mensaje humano y crea el archivo', () async {
    final user = UsuarioModel(
      id: '1',
      name: 'Ana López',
      email: 'ana@correo.com',
      role: RolUsuarioModel.student,
      company: 'Empresa Demo',
      phone: '0999999999',
      cedula: '1500000000',
      careerName: 'Software',
      periodName: '2025 - 2026',
      tutorAcademico: 'MSc. Pedro Cueva',
      tutorEmpresarial: 'Ing. Laura Torres',
      semestreNombre: 'Segundo',
      horasPracticas: 120,
    );

    final controller = ReportesController(
      repository: _MockAsistenciaRepository(),
      currentUser: user,
    );

    await controller.loadReportData();
    final result = await controller.generatePdfReport();

    expect(result, 'Generacion de pdf completa');
    expect(controller.isGeneratingPdf, isFalse);
  });
}
