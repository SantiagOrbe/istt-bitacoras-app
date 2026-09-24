import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

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