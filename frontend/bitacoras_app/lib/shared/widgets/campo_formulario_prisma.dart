import '../exports.dart';


class CampoFormularioPrisma extends StatefulWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final String textoSugerido;
  final String? textoAyuda;
  final IconData icono;
  final TextInputType tipoTeclado;
  final TextCapitalization capitalizacion;
  final bool ocultarTexto;
  final int maxLineas;
  final bool soloLectura;
  final VoidCallback? alPresionar;
  final Widget? accion;
  final String? mensajeError;
  final String? Function(String?)? validador;

  const CampoFormularioPrisma({
    super.key,
    required this.controlador,
    required this.etiqueta,
    required this.icono,
    this.textoSugerido = '',
    this.textoAyuda,
    this.tipoTeclado = TextInputType.text,
    this.capitalizacion = TextCapitalization.sentences,
    this.ocultarTexto = false,
    this.maxLineas = 1,
    this.soloLectura = false,
    this.alPresionar,
    this.accion,
    this.mensajeError,
    this.validador,
  });

  @override
  State<CampoFormularioPrisma> createState() => _CampoFormularioPrismaState();
}

class _CampoFormularioPrismaState extends State<CampoFormularioPrisma> {
  bool _estaSobre = false;

  Color get _colorAcento =>
      Color.lerp(AppColores.secondary, AppColores.warning, 0.30)!;

  @override
  Widget build(BuildContext context) {
    final colorBorde = _estaSobre ? _colorAcento : AppColores.outline;

    return MouseRegion(
      cursor: SystemMouseCursors.text,
      onEnter: (_) => setState(() => _estaSobre = true),
      onExit: (_) => setState(() => _estaSobre = false),
      child: TextFormField(
        controller: widget.controlador,
        keyboardType: widget.tipoTeclado,
        textCapitalization: widget.capitalizacion,
        obscureText: widget.ocultarTexto,
        maxLines: widget.ocultarTexto ? 1 : widget.maxLineas,
        readOnly: widget.soloLectura,
        onTap: widget.alPresionar,
        validator: widget.validador,
        style: const TextStyle(color: AppColores.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          labelText: widget.etiqueta,
          hintText: widget.textoSugerido.isEmpty ? null : widget.textoSugerido,
          helperText: widget.textoAyuda,
          labelStyle: AppEstiloTexto.body.copyWith(
            color: _estaSobre ? _colorAcento : AppColores.textSecondary,
          ),
          prefixIcon: Icon(
            widget.icono,
            color: _estaSobre ? _colorAcento : AppColores.primary,
          ),
          suffixIcon: widget.accion,
          errorText: widget.mensajeError,
          errorMaxLines: 2,
          errorStyle: AppEstiloTexto.caption.copyWith(color: AppColores.error),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorBorde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _colorAcento, width: 2),
          ),
        ),
      ),
    );
  }
}
