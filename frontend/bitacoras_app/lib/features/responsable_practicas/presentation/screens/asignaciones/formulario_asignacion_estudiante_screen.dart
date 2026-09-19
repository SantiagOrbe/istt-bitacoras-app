import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../../../app/apps.dart';
import '../../../../../app/auth_session.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/asignacion_estudiante_model.dart';
import '../../controllers/asignacion_estudiante_controller.dart';
import '../../widgets/asignaciones/formulario_asignacion_estudiante_body.dart';

class FormularioAsignacionEstudianteScreen extends StatelessWidget {
  final AsignacionEstudianteModel assignment;
  final AsignacionEstudianteController controller;

  const FormularioAsignacionEstudianteScreen({
    super.key,
    required this.assignment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: context.read<AuthSession>().currentUser!,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormularioAsignacionEstudianteBody(assignment: assignment, controller: controller),
      ),
    );
  }
}