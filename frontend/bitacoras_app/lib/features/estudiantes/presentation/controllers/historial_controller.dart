import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';


class HistorialController extends ChangeNotifier {
  final IAsistenciaRepositorio repository;

  HistorialController({required this.repository});

  bool isLoading = true;
  RegistroAsistenciaModel? activeRecord;
  List<RegistroAsistenciaModel> historyList = [];

  Future<void> fetchHistory() async {
    isLoading = true;
    notifyListeners();

    activeRecord = await repository.obtenerRegistroActual();
    historyList = await repository.obtenerHistorialAsistencia();

    isLoading = false;
    notifyListeners();
  }
}
