import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:flutter/material.dart';

import '../inicio_screen.dart';

class InicioResponsablePracticasScreen extends StatelessWidget {
  const InicioResponsablePracticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InicioScreen(
      user: FakeUsuarioRepository.practiceManager,
      actions: FakeTableroRepository().practiceManagerActions(),
    );
  }
}