import 'package:bitacoras_app/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:bitacoras_app/features/attendance/presentation/screens/history_screen.dart';
import 'package:bitacoras_app/features/attendance/presentation/screens/register_attendance_screen.dart';
import 'package:bitacoras_app/features/attendance/presentation/screens/reports_screen.dart';
import 'package:bitacoras_app/features/home/models/quick_action.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FakeDashboardRepository {
  FakeDashboardRepository._();

  static List<QuickAction> studentActions(BuildContext context) {
    return [
      QuickAction(
        title: 'Registrar asistencia',
        icon: Icons.login,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => AttendanceProvider(),
                child: const RegisterAttendanceScreen(),
              )),
          );
        },
      ),
      QuickAction(
        title: "Registrar\nSalida",
        icon: Icons.exit_to_app,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => AttendanceProvider(),
                child: const RegisterAttendanceScreen(isEntry: false),
              ),
            ),
          );
        },
      ),
      QuickAction(
        title: 'Historial',
        icon: Icons.history,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => AttendanceProvider(),
                child: const HistoryScreen(),
              ),
            ),
          );
        },
      ),
      QuickAction(
        title: 'Reportes', 
        icon: Icons.assignment,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportsScreen(),
            ),
          );
        },
      ),
    ];
  }

  static List<QuickAction> teacherActions() {
    return [
      QuickAction(
        title: 'Estudiantes',
        icon: Icons.groups,
        onTap: () {},
      ),
      QuickAction(
        title: 'Reportes',
        icon: Icons.bar_chart,
        onTap: () {},
      ),
      QuickAction(
        title: 'Bitácoras',
        icon: Icons.menu_book,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        icon: Icons.person,
        onTap: () {},
      ),
    ];
  }

  static List<QuickAction> academicTutorActions() {
    return [
      QuickAction(
        title: 'Practicantes',
        icon: Icons.school,
        onTap: () {},
      ),
      QuickAction(
        title: 'Seguimiento',
        icon: Icons.track_changes,
        onTap: () {},
      ),
      QuickAction(
        title: 'Reportes',
        icon: Icons.analytics,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        icon: Icons.person,
        onTap: () {},
      ),
    ];
  }

  static List<QuickAction> companyTutorActions() {
    return [
      QuickAction(
        title: 'Estudiantes',
        icon: Icons.groups,
        onTap: () {},
      ),
      QuickAction(
        title: 'Asistencia',
        icon: Icons.fact_check,
        onTap: () {},
      ),
      QuickAction(
        title: 'Actividades',
        icon: Icons.assignment,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        icon: Icons.person,
        onTap: () {},
      ),
    ];
  }

  static List<QuickAction> coordinatorActions() {
    return [
      QuickAction(
        title: 'Carreras',
        icon: Icons.account_tree,
        onTap: () {},
      ),
      QuickAction(
        title: 'Reportes',
        icon: Icons.bar_chart,
        onTap: () {},
      ),
      QuickAction(
        title: 'Estudiantes',
        icon: Icons.school,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        icon: Icons.person,
        onTap: () {},
      ),
    ];
  }

  static List<QuickAction> practiceManagerActions() {
    return [
      QuickAction(
        title: 'Empresas',
        icon: Icons.business,
        onTap: () {},
      ),
      QuickAction(
        title: 'Convenios',
        icon: Icons.handshake,
        onTap: () {},
      ),
      QuickAction(
        title: 'Prácticas',
        icon: Icons.work_history,
        onTap: () {},
      ),
      QuickAction(
        title: 'Mi perfil',
        icon: Icons.person,
        onTap: () {},
      ),
    ];
  }

  static List<QuickAction> adminActions() {
    return [
      QuickAction(
        title: 'Usuarios',
        icon: Icons.manage_accounts,
        onTap: () {},
      ),
      QuickAction(
        title: 'Roles',
        icon: Icons.admin_panel_settings,
        onTap: () {},
      ),
      QuickAction(
        title: 'Configuración',
        icon: Icons.settings,
        onTap: () {},
      ),
      QuickAction(
        title: 'Reportes',
        icon: Icons.bar_chart,
        onTap: () {},
      ),
    ];
  }
}