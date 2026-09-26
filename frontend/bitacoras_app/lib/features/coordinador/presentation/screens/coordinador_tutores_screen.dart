import 'package:bitacoras_app/features/coordinador/coordinador.dart';


class CoordinadorTutoresScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const CoordinadorTutoresScreen({super.key, required this.currentUser});

  @override
  State<CoordinadorTutoresScreen> createState() =>
      _CoordinadorTutoresScreenState();
}

class _CoordinadorTutoresScreenState extends State<CoordinadorTutoresScreen> {
  late final CoordinadorConsultaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: context.read<ICoordinadorRepository>(),
    );
    _controller.cargarTutores();
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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CoordinadorEncabezadoSeccion(
                icono: Icons.badge_rounded,
                titulo: 'Tutores académicos',
                subtitulo: '${_controller.tutores.length} registros activos',
                color: AppColores.primary,
              ),
              const SizedBox(height: 16),
              ..._controller.tutores.asMap().entries.map((entry) {
                final tutor = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CoordinadorDetalleCard(
                    title: tutor.nombre.isEmpty ? 'Tutor sin nombre' : tutor.nombre,
                    icon: Icons.badge_rounded,
                    details: [
                      MapEntry(
                        'Correo',
                        tutor.correo.isEmpty
                            ? 'Sin correo registrado'
                            : tutor.correo,
                      ),
                      MapEntry(
                        'Teléfono',
                        tutor.telefono.isEmpty
                            ? 'Sin teléfono registrado'
                            : tutor.telefono,
                      ),
                      MapEntry(
                        'Cédula',
                        tutor.cedula.isEmpty
                            ? 'Sin cédula registrada'
                            : tutor.cedula,
                      ),
                      MapEntry(
                        'Carrera',
                        tutor.carrera.isEmpty
                            ? widget.currentUser.careerName ?? 'Sin carrera registrada'
                            : tutor.carrera,
                      ),
                      MapEntry(
                        'Empresa asignada',
                        tutor.empresa.isEmpty
                            ? 'Sin empresa asignada'
                            : tutor.empresa,
                      ),
                      MapEntry('Estado', tutor.estaActivo ? 'Activo' : 'Inactivo'),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
