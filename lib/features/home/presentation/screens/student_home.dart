import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/students/presentation/controllers/attendance_provider.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_dashboard_repository.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Escuchar los cambios del estado de asistencia en tiempo real
    final attendanceProvider = context.watch<AttendanceProvider>();

    return LocationCheckerWrapper(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await SystemNavigator.pop();
        },
        child: HomePage(
          user: FakeUserRepository.student,
          actions: FakeDashboardRepository().studentActions(),
        ),
      ),
    ); 
  }
}