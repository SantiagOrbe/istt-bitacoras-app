import 'package:bitacoras_app/app/auth_session.dart';
import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../inicio_screen.dart';

class InicioTutorEmpresarialScreen extends StatelessWidget {
  final UsuarioModel? user;

  const InicioTutorEmpresarialScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final currentUser = user ?? context.read<AuthSession>().currentUser ?? FakeUsuarioRepository.companyTutor;

    return LocationCheckerWrapper(
      child: InicioScreen(
        user: currentUser,
        actions: FakeTableroRepository().companyTutorActions(),
      ),
    );
  }
}