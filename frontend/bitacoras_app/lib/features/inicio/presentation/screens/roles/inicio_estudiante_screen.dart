import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/estudiantes/domain/repositories/i_asistencia_repository.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:bitacoras_app/features/estudiantes/data/repositories/opciones_drawer_estudiante.dart';

import '../inicio_screen.dart';

class InicioEstudianteScreen extends StatefulWidget {
  final UsuarioModel? currentUser;

  const InicioEstudianteScreen({super.key, this.currentUser});

  @override
  State<InicioEstudianteScreen> createState() => _InicioEstudianteScreenState();
}

class _InicioEstudianteScreenState extends State<InicioEstudianteScreen>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  RegistroAsistenciaModel? _todayRecord;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCurrentRecord();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _loadCurrentRecord(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadCurrentRecord();
  }

  Future<void> _loadCurrentRecord() async {
    try {
      final record = await context
          .read<IAsistenciaRepository>()
          .getTodayRecord();
      if (!mounted) return;
      setState(() {
        _todayRecord = record;
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
    final hasRecord = _todayRecord != null;
    final hasActivities = _todayRecord?.hasActivities ?? false;
    final isClosed = _todayRecord?.exitTime != null;
    final actions = baseActions.map((action) {
      if (action.route == AppRoutes.attendance) {
        return action.copyWith(enabled: !hasRecord && !_isLoading);
      }
      if (action.route == AppRoutes.registerActivity) {
        return action.copyWith(
          enabled: hasRecord && !hasActivities && !isClosed && !_isLoading,
        );
      }
      if (action.route == AppRoutes.registerExitAttendance) {
        return action.copyWith(
          enabled: hasRecord && hasActivities && !isClosed && !_isLoading,
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
          drawerSections: getOpcionesDrawerEstudiante(
            canEnter: !hasRecord && !_isLoading,
            canActivities:
                hasRecord && !hasActivities && !isClosed && !_isLoading,
            canExit: hasRecord && hasActivities && !isClosed && !_isLoading,
          ),
          todayRecord: _todayRecord,
          isAttendanceLoading: _isLoading,
        ),
      ),
    );
  }
}
