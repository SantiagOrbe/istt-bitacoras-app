import '../exports.dart';

class BarraBusquedaPrisma extends StatefulWidget {
  final TextEditingController? controlador;
  final String etiqueta;
  final String textoSugerido;
  final String? atajo;
  final String? textoAyuda;
  final ValueChanged<String>? alCambiar;
  final VoidCallback? alLimpiar;

  const BarraBusquedaPrisma({
    super.key,
    this.controlador,
    this.etiqueta = 'Buscar',
    this.textoSugerido = 'Buscar registros',
    this.atajo,
    this.textoAyuda,
    this.alCambiar,
    this.alLimpiar,
  });

  @override
  State<BarraBusquedaPrisma> createState() => _BarraBusquedaPrismaState();
}

class _BarraBusquedaPrismaState extends State<BarraBusquedaPrisma> {
  late final FocusNode _nodoEnfoque;
  late final TextEditingController _controladorInterno;

  TextEditingController get _controlador =>
      widget.controlador ?? _controladorInterno;

  @override
  void initState() {
    super.initState();
    _nodoEnfoque = FocusNode()..addListener(_actualizarEstado);
    _controladorInterno = TextEditingController();
  }

  @override
  void dispose() {
    _nodoEnfoque
      ..removeListener(_actualizarEstado)
      ..dispose();
    _controladorInterno.dispose();
    super.dispose();
  }

  void _actualizarEstado() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final enfocado = _nodoEnfoque.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.etiqueta.toUpperCase(),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.only(bottom: 11),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20,
                color: enfocado ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controlador,
                  focusNode: _nodoEnfoque,
                  onChanged: widget.alCambiar,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: widget.textoSugerido,
                    hintStyle: const TextStyle(color: AppColors.textHint),
                  ),
                ),
              ),
              if (widget.alLimpiar != null && _controlador.text.isNotEmpty)
                IconButton(
                  onPressed: widget.alLimpiar,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppColors.textSecondary,
                  tooltip: 'Limpiar búsqueda',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                )
              else if (widget.atajo != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.outline),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    child: Text(
                      widget.atajo!,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (widget.textoAyuda != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.textoAyuda!.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
