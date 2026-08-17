import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../../inicio/data/repositories/fake_usuario_repository.dart';
import '../../../../inicio/presentation/widgets/inicio_app_bar.dart';
import '../../../data/repositories/fake_responsable_practicas_repository.dart';
import '../../controllers/asignacion_estudiante_controller.dart';
import '../../widgets/asignaciones/asignacion_estudiantes_body.dart';

class AsignacionEstudiantesScreen extends StatefulWidget {
  const AsignacionEstudiantesScreen({super.key});

  @override
  State<AsignacionEstudiantesScreen> createState() => _AsignacionEstudiantesScreenState();
}

class _AsignacionEstudiantesScreenState extends State<AsignacionEstudiantesScreen> {
  late final AsignacionEstudianteController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AsignacionEstudianteController(
      repository: FakeResponsablePracticasRepository(),
    );
    _controller.loadAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(
            user: FakeUsuarioRepository.practiceManager,
            showBackButton: true,
            showDrawerButton: false,
            onBackPressed: () => context.pop(),
          ),
          body: AsignacionEstudiantesBody(controller: _controller),
        );
      },
    );
  }
}