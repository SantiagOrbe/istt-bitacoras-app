import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitacoras_app/app/auth_session.dart';

import '../inicio_screen.dart';

class InicioCoordinadorScreen extends StatelessWidget {
  const InicioCoordinadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthSession>().currentUser ?? FakeUsuarioRepository.coordinator;
    return InicioScreen(
      user: user,
      actions: FakeTableroRepository().coordinatorActions(),
    );
  }
}