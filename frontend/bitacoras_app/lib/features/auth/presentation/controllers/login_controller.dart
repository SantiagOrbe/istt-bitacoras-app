import '../../auth.dart';


class LoginController extends ChangeNotifier {
  final IAuthRepository repositorio;

  LoginController({required this.repositorio});

  final TextEditingController controladorCorreo = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();

  bool estaCargando = false;
  bool mostrarContrasena = false;
  String? mensajeError;
  String? errorCorreo;
  String? errorContrasena;

  void alternarVisibilidadContrasena() {
    mostrarContrasena = !mostrarContrasena;
    notifyListeners();
  }

  Future<UsuarioModel?> iniciarSesion() async {
    final correo = controladorCorreo.text.trim();
    final contrasena = controladorContrasena.text;

    errorCorreo = null;
    errorContrasena = null;
    mensajeError = null;

    if (correo.isEmpty) {
      errorCorreo = 'Ingrese su correo institucional.';
    } else if (!correo.toLowerCase().endsWith('@est.itstena.edu.ec')) {
      errorCorreo = 'Use un correo @est.itstena.edu.ec.';
    }
    if (contrasena.trim().isEmpty) {
      errorContrasena = 'Ingrese su contraseña.';
    }
    if (errorCorreo != null || errorContrasena != null) {
      notifyListeners();
      return null;
    }

    estaCargando = true;
    mensajeError = null;
    notifyListeners();

    try {
      final usuario = await repositorio.login(
        email: correo,
        password: contrasena,
      );

      estaCargando = false;
      notifyListeners();
      return usuario;
    } catch (e) {
      estaCargando = false;
      if (e is ApiException && e.body is Map<String, dynamic>) {
        final body = e.body as Map<String, dynamic>;
        errorCorreo = _obtenerErrorCampo(body['email']);
        errorContrasena = _obtenerErrorCampo(body['password']);
        mensajeError =
            _obtenerErrorCampo(body['detail']) ??
            _obtenerErrorCampo(body['non_field_errors']);
      } else {
        mensajeError = e.toString().replaceAll('Exception: ', '');
      }
      notifyListeners();
      return null;
    }
  }

  String? _obtenerErrorCampo(dynamic value) {
    if (value is List && value.isNotEmpty) return value.first.toString();
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  @override
  void dispose() {
    controladorCorreo.dispose();
    controladorContrasena.dispose();
    super.dispose();
  }
}
