import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';

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
    final repository = context.read<IResponsablePracticasRepository>();
    repository.invalidateCache();
    _controller = AsignacionEstudianteController(repository: repository);
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
            user: context.read<AuthSession>().currentUser!,
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