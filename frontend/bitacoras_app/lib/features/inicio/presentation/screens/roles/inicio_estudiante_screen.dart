import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../inicio_screen.dart';

class InicioEstudianteScreen extends StatelessWidget {
  final UsuarioModel? currentUser;

  const InicioEstudianteScreen({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return LocationCheckerWrapper(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await SystemNavigator.pop();
        },
        child: InicioScreen(
          user: currentUser ?? FakeUsuarioRepository.student,
          actions: FakeTableroRepository().studentActions(),
        ),
      ),
    );
  }
}
