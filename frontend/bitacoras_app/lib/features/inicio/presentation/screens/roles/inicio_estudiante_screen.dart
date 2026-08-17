import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/estudiantes/presentation/controllers/asistencia_provider.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../inicio_screen.dart';

class InicioEstudianteScreen extends StatelessWidget {
  const InicioEstudianteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Escuchar los cambios del estado de asistencia en tiempo real
    final attendanceProvider = context.watch<AsistenciaProvider>();

    return LocationCheckerWrapper(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await SystemNavigator.pop();
        },
        child: InicioScreen(
          user: FakeUsuarioRepository.student,
          actions: FakeTableroRepository().studentActions(),
        ),
      ),
    );
  }
}
