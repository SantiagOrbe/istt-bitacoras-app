import '../../auth.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController controladorCorreo;
  final TextEditingController controladorContrasena;
  final bool mostrarContrasena;
  final bool estaCargando;
  final String? errorCorreo;
  final String? errorContrasena;
  final VoidCallback alAlternarContrasena;
  final VoidCallback alEnviar;

  const LoginForm({
    super.key,
    required this.controladorCorreo,
    required this.controladorContrasena,
    required this.mostrarContrasena,
    required this.estaCargando,
    this.errorCorreo,
    this.errorContrasena,
    required this.alAlternarContrasena,
    required this.alEnviar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CampoFormularioPrisma(
          controlador: controladorCorreo,
          etiqueta: 'Correo institucional',
          textoSugerido: 'ejemplo@est.itstena.edu.ec',
          icono: Icons.email_outlined,
          tipoTeclado: TextInputType.emailAddress,
          mensajeError: errorCorreo,
        ),
        AppSizes.gapV16,
        CampoFormularioPrisma(
          controlador: controladorContrasena,
          etiqueta: 'Contraseña',
          icono: Icons.lock_outline_rounded,
          ocultarTexto: !mostrarContrasena,
          mensajeError: errorContrasena,
          accion: IconButton(
            icon: Icon(
              mostrarContrasena
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: alAlternarContrasena,
          ),
        ),
        AppSizes.gapV24,
        BotonPrisma(
          texto: 'Iniciar sesión',
          icono: Icons.login_rounded,
          cargando: estaCargando,
          anchoCompleto: true,
          alPresionar: alEnviar,
        ),
      ],
    );
  }
}
