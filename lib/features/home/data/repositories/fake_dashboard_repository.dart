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
        title: 'Practicantes',
        subtitle: 'Alumnos a supervisar',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
        onTap: () {},
      ),
      QuickAction(
        title: 'Seguimiento',
        subtitle: 'Monitoreo en empresas',
        icon: Icons.track_changes_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.reports,
        onTap: () {},
      ),
      QuickAction(
        title: 'Reportes',
        subtitle: 'Evaluaciones y horas',
        icon: Icons.analytics_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.reports,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        subtitle: 'Datos personales',
        icon: Icons.person_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.profile,
        onTap: () {},
      ),
    ];
  }

  @override
  List<QuickAction> companyTutorActions() {
    return [
      QuickAction(
        title: 'Estudiantes',
        subtitle: 'Pasantes en la empresa',
        icon: Icons.groups_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
        onTap: () {},
      ),
      QuickAction(
        title: 'Asistencia',
        subtitle: 'Validación de registros',
        icon: Icons.fact_check_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.attendance,
        onTap: () {},
      ),
      QuickAction(
        title: 'Actividades',
        subtitle: 'Aprobar bitácoras diarias',
        icon: Icons.assignment_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.registerActivity,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        subtitle: 'Datos institucionales',
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
        subtitle: 'Gestión por coordinaciones',
        icon: Icons.account_tree_rounded,
        iconBackgroundColor: const Color(0xFF7B1FA2),
        route: AppRoutes.careerPeriod,
        onTap: () {},
      ),
      QuickAction(
        title: 'Reportes',
        subtitle: 'Métricas de la carrera',
        icon: Icons.bar_chart_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.reports,
        onTap: () {},
      ),
      QuickAction(
        title: 'Estudiantes',
        subtitle: 'Estado académico y prácticas',
        icon: Icons.school_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
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
        title: 'Empresas',
        subtitle: 'Catálogo de instituciones',
        icon: Icons.business_rounded,
        iconBackgroundColor: const Color(0xFF1E88E5),
        route: AppRoutes.userManagement,
        onTap: () {},
      ),
      QuickAction(
        title: 'Convenios',
        subtitle: 'Acuerdos vigentes',
        icon: Icons.handshake_rounded,
        iconBackgroundColor: const Color(0xFF00897B),
        route: AppRoutes.careerPeriod,
        onTap: () {},
      ),
      QuickAction(
        title: 'Prácticas',
        subtitle: 'Asignaciones de cupos',
        icon: Icons.work_history_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.registerActivity,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        subtitle: 'Datos personales',
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
        route: AppRoutes.careerPeriod,
        onTap: () {},
      ),
      QuickAction(
        title: 'Periodos Lectivos',
        subtitle: 'Administrar lapsos académicos',
        icon: Icons.date_range_rounded,
        iconBackgroundColor: const Color(0xFFF57C00),
        route: AppRoutes.careerPeriod,
        onTap: () {},
      ),
      QuickAction(
        title: 'Cursos y Paralelos',
        subtitle: 'Aulas, semestres y paralelos',
        icon: Icons.class_rounded,
        iconBackgroundColor: const Color(0xFF43A047),
        route: AppRoutes.careerPeriod,
        onTap: () {},
      ),
      QuickAction(
        title: 'Gestión de Bitácoras',
        subtitle: 'Auditoría y control de asistencias',
        icon: Icons.assignment_rounded,
        iconBackgroundColor: const Color(0xFFD81B60),
        route: AppRoutes.registerActivity,
        onTap: () {},
      ),
    ];
  }
}