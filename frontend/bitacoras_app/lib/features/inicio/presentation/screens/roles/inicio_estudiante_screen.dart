import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/estudiantes/domain/repositories/i_asistencia_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../inicio_screen.dart';

class InicioEstudianteScreen extends StatefulWidget {
  final UsuarioModel? currentUser;

  const InicioEstudianteScreen({super.key, this.currentUser});

  @override
  State<InicioEstudianteScreen> createState() => _InicioEstudianteScreenState();
}

class _InicioEstudianteScreenState extends State<InicioEstudianteScreen> {
  bool _hasActiveRecord = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentRecord();
  }

  Future<void> _loadCurrentRecord() async {
    try {
      final record = await context.read<IAsistenciaRepository>().getCurrentRecord();
      if (!mounted) return;
      setState(() {
        _hasActiveRecord = record != null;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.currentUser ?? FakeUsuarioRepository.student;
    final baseActions = FakeTableroRepository().studentActions();
    final actions = baseActions.map((action) {
      if (action.route == AppRoutes.attendance) {
        return action.copyWith(enabled: !_hasActiveRecord && !_isLoading);
      }
      if (action.route == AppRoutes.registerExitAttendance) {
        return action.copyWith(
          enabled: _hasActiveRecord && !_isLoading,
          route: AppRoutes.registerActivity,
        );
      }
      return action;
    }).toList();

    return LocationCheckerWrapper(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await SystemNavigator.pop();
        },
        child: InicioScreen(
          user: user,
          actions: actions,
        ),
      ),
    );
  }
}
