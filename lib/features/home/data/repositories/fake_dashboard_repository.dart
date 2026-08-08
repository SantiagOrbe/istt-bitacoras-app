import 'package:bitacoras_app/app/apps.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';
import '../../domain/models/quick_action.dart';
import '../../domain/models/user_role.dart';
import '../../domain/repositories/i_dashboard_repository.dart';

class FakeDashboardRepository implements IDashboardRepository {
  @override
  Future<List<QuickAction>> getActionsForRole(UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 300));

    switch (role) {
      case UserRole.student:
        return studentActions();
      case UserRole.teacher:
        return teacherActions();
      case UserRole.academicTutor:
        return academicTutorActions();
      case UserRole.companyTutor:
        return companyTutorActions();
      case UserRole.coordinator:
        return coordinatorActions();
      case UserRole.practiceManager:
        return practiceManagerActions();
      case UserRole.admin:
        return adminActions();
    }
  }

  @override
  List<QuickAction> studentActions() {
    return [
      QuickAction(
        title: 'Registrar asistencia',
        subtitle: 'Marcar entrada de jornada',
        icon: Icons.login_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.attendance,
        onTap: () {},
      ),
      QuickAction(
        title: 'Registrar salida',
        subtitle: 'Marcar fin de jornada',
        icon: Icons.exit_to_app_rounded,
        iconBackgroundColor: const Color(0xFFE53935),
        route: AppRoutes.registerExitAttendance,
        onTap: () {},
      ),
      QuickAction(
        title: 'Historial',
        subtitle: 'Asistencias e incidencias',
        icon: Icons.history_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.history,
        onTap: () {},
      ),
      QuickAction(
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
  List<QuickAction> teacherActions() {
    return [
      QuickAction(
        title: 'Estudiantes',
        subtitle: 'Lista de alumnos asignados',
        icon: Icons.groups_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
        onTap: () {},
      ),
      QuickAction(
        title: 'Reportes',
        subtitle: 'Avances e informes',
        icon: Icons.bar_chart_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.reports,
        onTap: () {},
      ),
      QuickAction(
        title: 'Bitácoras',
        subtitle: 'Revisión y firma',
        icon: Icons.menu_book_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.registerActivity,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        subtitle: 'Información del docente',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.profile,
        onTap: () {},
      ),
    ];
  }

  @override
  List<QuickAction> academicTutorActions() {
    return [
      QuickAction(
        title: 'Mis Tutoriados',
        subtitle: 'Alumnos a supervisar',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.assignedStudents,
        onTap: () {},
      ),
      QuickAction(
        title: 'Seguimiento',
        subtitle: 'Monitoreo en empresas',
        icon: Icons.track_changes_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.academicTutorTracking,
        onTap: () {},
      ),
      QuickAction(
        title: 'Registrar Entrada',
        subtitle: 'Hoja de ruta inicial',
        icon: Icons.assignment_turned_in_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.academicTutorRegisterVisit,
        onTap: () {},
      ),
      QuickAction(
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
  List<QuickAction> companyTutorActions() {
    return [
      QuickAction(
        title: 'Pasantes Asignados',
        subtitle: 'Alumnos en mi empresa',
        icon: Icons.people_outline_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.assignedStudents,
        onTap: () {},
      ),
      QuickAction(
        title: 'Seguimiento',
        subtitle: 'Bitácoras y horas acumuladas',
        icon: Icons.analytics_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.companyTutorTracking,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi Perfil',
        subtitle: 'Datos de la empresa y personales',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.profile,
        onTap: () {},
      ),
    ];
  }

  @override
  List<QuickAction> coordinatorActions() {
    return [
      QuickAction(
        title: 'Carreras',
        subtitle: 'Consulta de carreras',
        icon: Icons.account_tree_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.coordinatorCareers,
        onTap: () {},
      ),
      QuickAction(
        title: 'Estudiantes',
        subtitle: 'Consulta de estudiantes',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.coordinatorStudents,
        onTap: () {},
      ),
      QuickAction(
        title: 'Tutores',
        subtitle: 'Consulta de tutores',
        icon: Icons.badge_rounded,
        iconBackgroundColor: const Color(0xFFE65100),
        route: AppRoutes.coordinatorTutors,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        subtitle: 'Ajustes de cuenta',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.profile,
        onTap: () {},
      ),
    ];
  }
  @override
  List<QuickAction> practiceManagerActions() {
    return [
      QuickAction(
        title: 'Gestión de Empresas',
        subtitle: 'Catálogo de instituciones y convenios',
        icon: Icons.business_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.responsablePracticasCompanies,
        onTap: () {},
      ),
      QuickAction(
        title: 'Asignación de Estudiantes',
        subtitle: 'Vincular tutores académicos y empresariales',
        icon: Icons.person_add_alt_1_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.responsablePracticasAssignStudents,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        subtitle: 'Datos personales y cuenta',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.profile,
        onTap: () {},
      ),
    ];
  }
  @override
  List<QuickAction> adminActions() {
    return [
      QuickAction(
        title: 'Gestión de Usuarios',
        subtitle: 'Estudiantes, Tutores y Coordinadores',
        icon: Icons.people_alt_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
        onTap: () {},
      ),
      QuickAction(
        title: 'Carreras y Periodos',
        subtitle: 'Asignar prácticas por semestre/carrera',
        icon: Icons.account_tree_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.careerPeriod,
        onTap: () {},
      ),
      QuickAction(
        title: 'Gestión de Carreras',
        subtitle: 'Crear y administrar carreras ISTT',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.careerManagement,
        onTap: () {},
      ),
      QuickAction(
        title: 'Periodos Lectivos',
        subtitle: 'Administrar lapsos académicos',
        icon: Icons.date_range_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.periodManagement,
        onTap: () {},
      ),
      QuickAction(
        title: 'Cursos',
        subtitle: 'Niveles y semestres académicos',
        icon: Icons.class_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.cycleManagement,
        onTap: () {},
      ),
      QuickAction(
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