import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorCarrerasScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const CoordinadorCarrerasScreen({super.key, required this.currentUser});

  @override
  State<CoordinadorCarrerasScreen> createState() =>
      _CoordinadorCarrerasScreenState();
}

class _CoordinadorCarrerasScreenState extends State<CoordinadorCarrerasScreen> {
  late final CoordinadorConsultaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: context.read<ICoordinadorRepository>(),
    );
    _controller.cargarCarreras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.estaCargando) {
            return const Center(
              child: CircularProgressIndicator(color: AppColores.primary),
            );
          }

          if (_controller.carreras.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No hay una carrera asignada para este coordinador.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColores.textSecondary),
                ),
              ),
            );
          }

          final carrera = _controller.carreras.first;
          final semestres = _controller.datosCarrera?.semestres ?? const [];
          final paralelos = _controller.datosCarrera?.paralelos ?? const [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TarjetaResumenCarrera(
                carrera: carrera,
                semestres: semestres,
                paralelos: paralelos,
              ),
              const SizedBox(height: 16),
              ...semestres.map(
                (semestre) => TarjetaSemestreCarrera(
                  semestre: semestre,
                  paralelos: paralelos,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

