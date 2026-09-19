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
  Map<String, dynamic>? _practiceProgress;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCurrentRecord();
    _loadPracticeProgress();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        _loadCurrentRecord();
        _loadPracticeProgress();
      },
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
    if (state == AppLifecycleState.resumed) {
      _loadCurrentRecord();
      _loadPracticeProgress();
    }
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

  Future<void> _loadPracticeProgress() async {
    try {
      final progress = await context
          .read<IAsistenciaRepository>()
          .getStudentPracticeProgress();
      if (!mounted) return;
      setState(() {
        _practiceProgress = progress;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _practiceProgress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.currentUser ?? FakeUsuarioRepository.student;
    final baseActions = FakeTableroRepository().studentActions();
    final hasRecord = _todayRecord != null;
    final hasActivities = _todayRecord?.hasActivities ?? false;
    final isClosed = _todayRecord?.exitTime != null;
    final isComplete = (_practiceProgress?['completo'] ?? false) == true;
    final actions = baseActions.map((action) {
      if (action.route == AppRoutes.attendance) {
        return action.copyWith(enabled: !hasRecord && !_isLoading && !isComplete);
      }
      if (action.route == AppRoutes.registerActivity) {
        return action.copyWith(
          enabled: hasRecord && !hasActivities && !isClosed && !_isLoading && !isComplete,
        );
      }
      if (action.route == AppRoutes.registerExitAttendance) {
        return action.copyWith(
          enabled: hasRecord && hasActivities && !isClosed && !_isLoading && !isComplete,
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
            canEnter: !hasRecord && !_isLoading && !isComplete,
            canActivities:
                hasRecord && !hasActivities && !isClosed && !_isLoading && !isComplete,
            canExit: hasRecord && hasActivities && !isClosed && !_isLoading && !isComplete,
          ),
          todayRecord: _todayRecord,
          isAttendanceLoading: _isLoading,
        ),
      ),
    );
  }
}
