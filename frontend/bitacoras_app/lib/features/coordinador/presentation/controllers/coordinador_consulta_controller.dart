import 'package:bitacoras_app/features/coordinador/coordinador.dart';


class CoordinadorConsultaController extends ChangeNotifier {
  final ICoordinadorRepository repository;

  List<CoordinadorEstudianteModel> estudiantes = const [];
  List<CoordinadorCarreraModel> carreras = const [];
  List<CoordinadorTutorModel> tutores = const [];
  bool estaCargando = false;
  CoordinadorDatosModel? datosCarrera;

  CoordinadorConsultaController({required this.repository});

  Future<void> cargarEstudiantes() async {
    await _ejecutarConsulta(() async {
      datosCarrera = await repository.getDatosCarrera();
      estudiantes = datosCarrera?.estudiantes ?? const [];
    });
  }

  Future<void> cargarCarreras() async {
    await _ejecutarConsulta(() async {
      datosCarrera = await repository.getDatosCarrera();
      final nombreCarrera = datosCarrera?.carrera.trim() ?? '';

      carreras = nombreCarrera.isEmpty
          ? const []
          : [
              CoordinadorCarreraModel(
                id: '',
                nombre: nombreCarrera,
                codigo: '',
                sigla: '',
                modalidad: '',
                estaActiva: true,
              ),
            ];
    });
  }

  Future<void> cargarTutores() async {
    await _ejecutarConsulta(() async {
      datosCarrera = await repository.getDatosCarrera();
      tutores = datosCarrera?.tutores ?? const [];
    });
  }

  Future<void> _ejecutarConsulta(Future<void> Function() consulta) async {
    estaCargando = true;
    notifyListeners();
    try {
      await consulta();
    } finally {
      estaCargando = false;
      notifyListeners();
    }
  }
}
