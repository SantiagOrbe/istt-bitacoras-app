import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';


class HistorialController extends ChangeNotifier {
  final IAsistenciaRepository repository;

  HistorialController({required this.repository});

  bool isLoading = true;
  RegistroAsistenciaModel? activeRecord;
  List<RegistroAsistenciaModel> historyList = [];

  Future<void> fetchHistory() async {
    isLoading = true;
    notifyListeners();

    activeRecord = await repository.getCurrentRecord();
    historyList = await repository.getAttendanceHistory();

    isLoading = false;
    notifyListeners();
  }
}
