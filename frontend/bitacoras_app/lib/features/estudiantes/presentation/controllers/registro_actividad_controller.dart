import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';


class RegistroActividadController extends ChangeNotifier {
  final IAsistenciaRepositorio repository;
  final BitacoraRepositorioImpl bitacoraRepository;

  RegistroActividadController({
    required this.repository,
    required this.bitacoraRepository,
  });

  final List<TextEditingController> controllers = [TextEditingController()];
  bool isLoading = false;
  bool canRegister = false;
  String? validationMessage;

  Future<void> init() async {
    await validateLocation();
  }

  Future<bool> validateLocation() async {
    try {
      final company = await repository.obtenerUbicacionEmpresaAsignada();
      if (!await Geolocator.isLocationServiceEnabled()) {
        validationMessage = 'Active el GPS para registrar sus actividades.';
        canRegister = false;
        notifyListeners();
        return false;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        validationMessage = 'Se requieren permisos de ubicación.';
        canRegister = false;
        notifyListeners();
        return false;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        company.latitude,
        company.longitude,
      );
      canRegister = distance <= company.allowedRadiusMeters;
      validationMessage = canRegister
          ? null
          : 'Está fuera del rango permitido para ${company.name}.';
    } catch (_) {
      canRegister = false;
      validationMessage = 'No se pudo verificar la ubicación actual.';
    }
    notifyListeners();
    return canRegister;
  }

  void addActivityField() {
    controllers.add(TextEditingController());
    notifyListeners();
  }

  void removeActivityField(int index) {
    if (controllers.length > 1) {
      controllers[index].dispose();
      controllers.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> saveActivities() async {
    validationMessage = null;

    final descriptions = controllers
        .map((controller) => controller.text.trim())
        .where((description) => description.isNotEmpty)
        .toList();

    if (descriptions.isEmpty) {
      validationMessage = 'Ingrese al menos una actividad.';
      notifyListeners();
      return false;
    }

    final validDescription = RegExp(r'^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ\s]+$');
    if (descriptions.any((description) => !validDescription.hasMatch(description))) {
      validationMessage =
          'No se pueden usar números ni símbolos; escriba solo letras y espacios.';
      notifyListeners();
      return false;
    }

    final letterCount = RegExp(r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]');
    if (descriptions.any(
      (description) => letterCount.allMatches(description).length < 20,
    )) {
      validationMessage =
          'Cada actividad debe tener al menos 20 letras.';
      notifyListeners();
      return false;
    }

    if (!await validateLocation()) return false;

    isLoading = true;
    notifyListeners();

    final currentRecord = await repository.obtenerRegistroActual();
    if (currentRecord == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      for (final description in descriptions) {
        await bitacoraRepository.crearActividad({
          'descripcion': description,
          'registro_practica': currentRecord.id,
        });
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return true;
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
