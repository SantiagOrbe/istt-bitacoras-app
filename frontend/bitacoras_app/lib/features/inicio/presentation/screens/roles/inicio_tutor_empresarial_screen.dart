import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import '../inicio_screen.dart';

class InicioTutorEmpresarialScreen extends StatelessWidget {
  const InicioTutorEmpresarialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocationCheckerWrapper(
      child: InicioScreen(
        user: FakeUsuarioRepository.companyTutor,
        actions: FakeTableroRepository().companyTutorActions(),
      ),
    );
  }
}