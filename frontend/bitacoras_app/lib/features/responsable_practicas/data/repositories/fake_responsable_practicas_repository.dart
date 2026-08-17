import 'package:flutter/material.dart';
import '../../../../app/apps.dart';
import '../../domain/models/empresa_model.dart';
import '../../domain/models/asignacion_estudiante_model.dart';
import '../../domain/repositories/i_responsable_practicas_repository.dart';

class FakeResponsablePracticasRepository implements IResponsablePracticasRepository {
  final List<EmpresaModel> _companies = [
    const EmpresaModel(
      id: '1',
      name: 'GAD Municipal de Tena',
      ruc: '1560001160001',
      address: 'Av. 15 de Noviembre y Rubén Baquero',
      phone: '062886452',
      email: 'contacto@tena.gob.ec',
      legalRepresentative: 'Ing. Carlos Mendoza',
      agreementNumber: 'CONV-2025-001',
      isActive: true,
    ),
    const EmpresaModel(
      id: '2',
      name: 'Ministerio de Educación (Distrito Tena)',
      ruc: '1560002280001',
      address: 'Calle Jumandy y Tarqui',
      phone: '062887110',
      email: 'educacion.tena@educacion.gob.ec',
      legalRepresentative: 'Leda. María Ramos',
      agreementNumber: 'CONV-2025-008',
      isActive: true,
    ),
    const EmpresaModel(
      id: '3',
      name: 'Empresa Eléctrica Ambato SA (EERSSA)',
      ruc: '1890001420001',
      address: 'Calle Rocafuerte y 12 de Febrero',
      phone: '062886221',
      email: 'servicios@eerssa.com.ec',
      legalRepresentative: 'Ing. Roberto Silva',
      agreementNumber: 'CONV-2026-003',
      isActive: true,
    ),
  ];

  final List<AsignacionEstudianteModel> _assignments = [
    const AsignacionEstudianteModel(
      id: 'asg-101',
      studentId: 'std-001',
      studentName: 'Santiago Orbe',
      studentIdentification: '1500892341',
      career: 'Desarrollo de Software',
      academicTutorId: 'tut-acad-01',
      academicTutorName: 'Ing. Fernando Pérez',
      companyTutorId: 'tut-emp-01',
      companyTutorName: 'Ing. Carlos Mendoza',
      companyId: '1',
      companyName: 'GAD Municipal de Tena',
      isAssigned: true,
    ),
    const AsignacionEstudianteModel(
      id: 'asg-102',
      studentId: 'std-002',
      studentName: 'Andres Orbe',
      studentIdentification: '1500741258',
      career: 'Desarrollo de Software',
      academicTutorId: null,
      academicTutorName: null,
      companyTutorId: null,
      companyTutorName: null,
      companyId: null,
      companyName: null,
      isAssigned: false,
    ),
    const AsignacionEstudianteModel(
      id: 'asg-103',
      studentId: 'std-003',
      studentName: 'Andree Ramos',
      studentIdentification: '1500987654',
      career: 'Desarrollo de Software',
      academicTutorId: 'tut-acad-02',
      academicTutorName: 'Ing. Patricia Gómez',
      companyTutorId: 'tut-emp-02',
      companyTutorName: 'Leda. María Ramos',
      companyId: '2',
      companyName: 'Ministerio de Educación',
      isAssigned: true,
    ),
    const AsignacionEstudianteModel(
      id: 'asg-104',
      studentId: 'std-004',
      studentName: 'Stalin López',
      studentIdentification: '1500321654',
      career: 'Desarrollo de Software',
      academicTutorId: null,
      academicTutorName: null,
      companyTutorId: null,
      companyTutorName: null,
      companyId: null,
      companyName: null,
      isAssigned: false,
    ),
  ];

  @override
  List<AccionRapidaModel> responsablePracticasActions() {
    return [
      AccionRapidaModel(
        title: 'Gestión de Empresas',
        subtitle: 'Catálogo de instituciones y convenios',
        icon: Icons.business_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.responsablePracticasCompanies,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Asignación de Estudiantes',
        subtitle: 'Vincular tutores académicos y empresariales',
        icon: Icons.person_add_alt_1_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.responsablePracticasAssignStudents,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Mi perfil',
        subtitle: 'Datos personales y cuenta',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.perfil,
        onTap: () {},
      ),
    ];
  }

  @override
  Future<List<EmpresaModel>> getCompanies({String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_companies);
  }

  @override
  Future<EmpresaModel?> getCompanyById(String id) async => null;

  @override
  Future<bool> saveCompany(EmpresaModel company) async => true;

  @override
  Future<bool> toggleCompanyActiveStatus(String id, bool isActive) async => true;

  @override
  Future<List<AsignacionEstudianteModel>> getStudentAssignments({
    String? query,
    bool? pendingOnly,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var result = List<AsignacionEstudianteModel>.from(_assignments);

    if (pendingOnly == true) {
      result = result.where((a) => !a.isAssigned).toList();
    }

    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      result = result.where((a) {
        return a.studentName.toLowerCase().contains(lowerQuery) ||
            a.studentIdentification.contains(lowerQuery);
      }).toList();
    }

    return result;
  }

  @override
  Future<bool> assignStudent({
    required String assignmentId,
    required String academicTutorId,
    required String companyTutorId,
    required String companyId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _assignments.indexWhere((a) => a.id == assignmentId);
    if (index >= 0) {
      final company = _companies.firstWhere((c) => c.id == companyId);
      _assignments[index] = _assignments[index].copyWith(
        academicTutorId: academicTutorId,
        academicTutorName: academicTutorId == 'tut-acad-01' ? 'Ing. Fernando Pérez' : 'Ing. Patricia Gómez',
        companyTutorId: companyTutorId,
        companyTutorName: company.legalRepresentative,
        companyId: company.id,
        companyName: company.name,
        isAssigned: true,
      );
      return true;
    }
    return false;
  }
}