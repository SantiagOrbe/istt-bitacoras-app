import '../../auth.dart';

class RegisterScreen extends StatefulWidget {
  final IAuthRepository authRepository;

  const RegisterScreen({super.key, required this.authRepository});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _claveFormulario = GlobalKey<FormState>();
  final _controladorCorreo = TextEditingController();
  final _controladorContrasena = TextEditingController();
  final _controladorConfirmacion = TextEditingController();
  bool _estaCargando = false;
  bool _mostrarContrasena = false;
  bool _mostrarConfirmacion = false;
  String? _mensajeServidor;

  @override
  void dispose() {
    _controladorCorreo.dispose();
    _controladorContrasena.dispose();
    _controladorConfirmacion.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _mensajeServidor = null);
    if (!(_claveFormulario.currentState?.validate() ?? false)) return;

    setState(() => _estaCargando = true);
    try {
      await widget.authRepository.register(
        email: _controladorCorreo.text.trim(),
        password: _controladorContrasena.text,
        confirmPassword: _controladorConfirmacion.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso. Ahora puedes iniciar sesión.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go(AppRoutes.login);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _mensajeServidor = _obtenerMensajeError(error);
        _estaCargando = false;
      });
    }
  }

  String _obtenerMensajeError(Object error) {
    if (error is ApiException && error.body is Map<String, dynamic>) {
      final body = error.body as Map<String, dynamic>;
      for (final field in ['email', 'password', 'confirm_password', 'detail']) {
        final value = body[field];
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String && value.isNotEmpty) return value;
      }
    }
    if (error is ApiException) return error.message;
    return error.toString().replaceAll('Exception: ', '');
  }

  String? _validarCorreo(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingrese su correo institucional.';
    if (!email.toLowerCase().endsWith('@est.itstena.edu.ec')) {
      return 'Use un correo @est.itstena.edu.ec.';
    }
    return null;
  }

  String? _validarContrasena(String? value) {
    if ((value ?? '').isEmpty) return 'Ingrese una contraseña.';
    if ((value ?? '').length < 8) return 'Use al menos 8 caracteres.';
    return null;
  }

  String? _validarConfirmacion(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme su contraseña.';
    if (value != _controladorContrasena.text) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Registro de Usuarios'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _claveFormulario,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Registro institucional', style: AppTextStyles.title),
                AppSizes.gapV8,
                Text(
                  'Crea tu cuenta con tu correo institucional.',
                  style: AppTextStyles.body,
                ),
                AppSizes.gapV24,
                CampoFormularioPrisma(
                  controlador: _controladorCorreo,
                  etiqueta: 'Correo institucional',
                  textoSugerido: 'usuario@est.itstena.edu.ec',
                  icono: Icons.email_outlined,
                  tipoTeclado: TextInputType.emailAddress,
                  validador: _validarCorreo,
                ),
                AppSizes.gapV16,
                CampoFormularioPrisma(
                  controlador: _controladorContrasena,
                  etiqueta: 'Contraseña',
                  icono: Icons.lock_outline_rounded,
                  ocultarTexto: !_mostrarContrasena,
                  validador: _validarContrasena,
                  accion: IconButton(
                    icon: Icon(
                      _mostrarContrasena
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(
                      () => _mostrarContrasena = !_mostrarContrasena,
                    ),
                  ),
                ),
                AppSizes.gapV16,
                CampoFormularioPrisma(
                  controlador: _controladorConfirmacion,
                  etiqueta: 'Confirmar contraseña',
                  icono: Icons.lock_reset_outlined,
                  ocultarTexto: !_mostrarConfirmacion,
                  validador: _validarConfirmacion,
                  accion: IconButton(
                    icon: Icon(
                      _mostrarConfirmacion
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(
                      () => _mostrarConfirmacion = !_mostrarConfirmacion,
                    ),
                  ),
                ),
                if (_mensajeServidor != null) ...[
                  AppSizes.gapV16,
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.errorSoft,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      _mensajeServidor!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
                AppSizes.gapV24,
                BotonPrisma(
                  texto: 'Registrarme',
                  icono: Icons.person_add_alt_1,
                  cargando: _estaCargando,
                  anchoCompleto: true,
                  alPresionar: _registrar,
                ),
                AppSizes.gapV8,
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
