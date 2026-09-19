import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/app/auth_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../inicio_screen.dart';

class InicioResponsablePracticasScreen extends StatelessWidget {
  const InicioResponsablePracticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InicioScreen(
          user: context.read<AuthSession>().currentUser!,
      actions: FakeTableroRepository().practiceManagerActions(),
    );
  }
}