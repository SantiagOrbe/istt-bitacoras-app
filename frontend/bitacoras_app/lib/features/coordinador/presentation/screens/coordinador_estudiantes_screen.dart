import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorEstudiantesScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const CoordinadorEstudiantesScreen({super.key, required this.currentUser});

  @override
  State<CoordinadorEstudiantesScreen> createState() =>
      _CoordinadorEstudiantesScreenState();
}

class _CoordinadorEstudiantesScreenState
    extends State<CoordinadorEstudiantesScreen> {
  late final CoordinadorConsultaController _controller;
  final Map<String, String?> _paralelosSeleccionados = {};

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: context.read<ICoordinadorRepository>(),
    );
    _controller.cargarEstudiantes();
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
          final estudiantesPorSemestre =
              <String, Map<String, List<CoordinadorEstudianteModel>>>{};
          for (final estudiante in _controller.estudiantes) {
            final semestre = estudiante.semestre.isEmpty
                ? 'Semestre sin asignar'
                : estudiante.semestre;
            final paralelo = estudiante.paralelo.isEmpty
                ? 'Paralelo sin asignar'
                : estudiante.paralelo;
            estudiantesPorSemestre.putIfAbsent(semestre, () => {});
            estudiantesPorSemestre[semestre]!
                .putIfAbsent(paralelo, () => [])
                .add(estudiante);
          }

          void seleccionarParalelo(String semestre, String paralelo) {
            setState(() {
              _paralelosSeleccionados[semestre] =
                  _paralelosSeleccionados[semestre] == paralelo
                      ? null
                      : paralelo;
            });
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CoordinadorEncabezadoSeccion(
                icono: Icons.groups_rounded,
                titulo: 'Estudiantes',
                subtitulo:
                    _controller.datosCarrera?.carrera.isNotEmpty == true
                    ? _controller.datosCarrera!.carrera
                    : widget.currentUser.careerName ?? 'Mi carrera',
                color: AppColores.primary,
              ),
              const SizedBox(height: 16),
              ...estudiantesPorSemestre.entries.map(
                (semestre) => CoordinadorGrupoSemestre(
                  nombreSemestre: semestre.key,
                  paralelos: semestre.value,
                  paraleloSeleccionado: _paralelosSeleccionados[semestre.key],
                  onSeleccionarParalelo: (paralelo) => seleccionarParalelo(
                    semestre.key,
                    paralelo,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

