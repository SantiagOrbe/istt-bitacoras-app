import 'package:bitacoras_app/app/apps.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';
import '../../domain/models/accion_rapida_model.dart';
import '../../domain/models/rol_usuario_model.dart';
import '../../domain/repositories/i_tablero_repository.dart';

class FakeTableroRepository implements ITableroRepository {
  @override
  Future<List<AccionRapidaModel>> getActionsForRole(RolUsuarioModel role) async {
    await Future.delayed(const Duration(milliseconds: 300));

    switch (role) {
      case RolUsuarioModel.student:
        return studentActions();
      case RolUsuarioModel.teacher:
        return teacherActions();
      case RolUsuarioModel.academicTutor:
        return academicTutorActions();
      case RolUsuarioModel.companyTutor:
        return companyTutorActions();
      case RolUsuarioModel.coordinator:
        return coordinatorActions();
      case RolUsuarioModel.practiceManager:
        return practiceManagerActions();
      case RolUsuarioModel.admin:
        return adminActions();
    }
  }

  @override
  List<AccionRapidaModel> studentActions() {
    return [
      AccionRapidaModel(
        title: 'Registrar asistencia',
        subtitle: 'Marcar entrada de jornada',
        icon: Icons.login_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.attendance,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Registrar salida',
        subtitle: 'Marcar fin de jornada',
        icon: Icons.exit_to_app_rounded,
        iconBackgroundColor: const Color(0xFFE53935),
        route: AppRoutes.registerExitAttendance,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Historial',
        subtitle: 'Asistencias e incidencias',
        icon: Icons.history_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.history,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Reportes',
        subtitle: 'Descargar PDF de bitácoras',
        icon: Icons.assignment_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.reports,
        onTap: () {},
      ),
    ];
  }

  @override
  List<AccionRapidaModel> teacherActions() {
    return [
      AccionRapidaModel(
        title: 'Estudiantes',
        subtitle: 'Lista de alumnos asignados',
        icon: Icons.groups_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Reportes',
        subtitle: 'Avances e informes',
        icon: Icons.bar_chart_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.reports,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Bitácoras',
        subtitle: 'Revisión y firma',
        icon: Icons.menu_book_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.registerActivity,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Mi perfil',
        subtitle: 'Información del docente',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.perfil,
        onTap: () {},
      ),
    ];
  }

  @override
  List<AccionRapidaModel> academicTutorActions() {
    return [
      AccionRapidaModel(
        title: 'Mis Tutoriados',
        subtitle: 'Alumnos a supervisar',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.assignedStudents,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Seguimiento',
        subtitle: 'Monitoreo en empresas',
        icon: Icons.track_changes_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.academicTutorTracking,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Registrar Entrada',
        subtitle: 'Hoja de ruta inicial',
        icon: Icons.assignment_turned_in_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.academicTutorRegisterVisit,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Registrar Salida',
        subtitle: 'Hoja de ruta institucional',
        icon: Icons.exit_to_app_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.academicTutorRegisterDeparture,
        onTap: () {},
      ),

    ];
  }

  @override
  List<AccionRapidaModel> companyTutorActions() {
    return [
      AccionRapidaModel(
        title: 'Pasantes Asignados',
        subtitle: 'Alumnos en mi empresa',
        icon: Icons.people_outline_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.assignedStudents,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Seguimiento',
        subtitle: 'Bitácoras y horas acumuladas',
        icon: Icons.analytics_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.companyTutorTracking,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Mi Perfil',
        subtitle: 'Datos de la empresa y personales',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.perfil,
        onTap: () {},
      ),
    ];
  }

  @override
  List<AccionRapidaModel> coordinatorActions() {
    return [
      AccionRapidaModel(
        title: 'Carreras',
        subtitle: 'Consulta de carreras',
        icon: Icons.account_tree_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.coordinatorCareers,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Estudiantes',
        subtitle: 'Consulta de estudiantes',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.coordinatorStudents,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Tutores',
        subtitle: 'Consulta de tutores',
        icon: Icons.badge_rounded,
        iconBackgroundColor: const Color(0xFFE65100),
        route: AppRoutes.coordinatorTutors,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Mi perfil',
        subtitle: 'Ajustes de cuenta',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.perfil,
        onTap: () {},
      ),
    ];
  }
  @override
  List<AccionRapidaModel> practiceManagerActions() {
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
  List<AccionRapidaModel> adminActions() {
    return [
      AccionRapidaModel(
        title: 'Gestión de Usuarios',
        subtitle: 'Estudiantes, Tutores y Coordinadores',
        icon: Icons.people_alt_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Carreras y Periodos',
        subtitle: 'Asignar prácticas por semestre/carrera',
        icon: Icons.account_tree_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.careerPeriod,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Gestión de Carreras',
        subtitle: 'Crear y administrar carreras ISTT',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.careerManagement,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Periodos Lectivos',
        subtitle: 'Administrar lapsos académicos',
        icon: Icons.date_range_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.periodManagement,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Cursos',
        subtitle: 'Niveles y semestres académicos',
        icon: Icons.class_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.cycleManagement,
        onTap: () {},
      ),
      AccionRapidaModel(
        title: 'Paralelos',
        subtitle: 'Secciones y jornadas por curso',
        icon: Icons.groups_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.parallelManagement,
        onTap: () {},
      ),
    ];
  }
}