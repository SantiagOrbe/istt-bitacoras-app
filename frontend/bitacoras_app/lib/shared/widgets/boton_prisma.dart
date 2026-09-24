import '../exports.dart';

class BotonPrisma extends StatefulWidget {
  final String texto;
  final VoidCallback? alPresionar;
  final IconData? icono;
  final bool cargando;
  final bool anchoCompleto;

  const BotonPrisma({
    super.key,
    required this.texto,
    this.alPresionar,
    this.icono,
    this.cargando = false,
    this.anchoCompleto = false,
  });

  @override
  State<BotonPrisma> createState() => _BotonPrismaState();
}

class _BotonPrismaState extends State<BotonPrisma> {
  bool _estaSobre = false;

  @override
  Widget build(BuildContext context) {
    final estaHabilitado = widget.alPresionar != null && !widget.cargando;
    final colorTexto = estaHabilitado
        ? AppColors.surface
        : AppColors.textDisabled;

    return MouseRegion(
      cursor: estaHabilitado
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _estaSobre = true),
      onExit: (_) => setState(() => _estaSobre = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(
          0,
          _estaSobre && estaHabilitado ? -1 : 0,
          0,
        ),
        width: widget.anchoCompleto ? double.infinity : null,
        height: 48,
        decoration: BoxDecoration(
          color: estaHabilitado ? AppColors.primary : AppColors.disabledSurface,
          border: Border.all(
            color: estaHabilitado ? AppColors.primary : AppColors.disabled,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: _estaSobre && estaHabilitado
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.16),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                height: _estaSobre && estaHabilitado ? 4 : 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.warning],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: estaHabilitado ? widget.alPresionar : null,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: widget.cargando
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorTexto,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.texto.toUpperCase(),
                                style: AppTextStyles.button.copyWith(
                                  color: colorTexto,
                                  fontSize: 12,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              if (widget.icono != null) ...[
                                const SizedBox(width: 10),
                                AnimatedSlide(
                                  duration: const Duration(milliseconds: 220),
                                  offset: _estaSobre && estaHabilitado
                                      ? const Offset(0.2, 0)
                                      : Offset.zero,
                                  child: Icon(
                                    widget.icono,
                                    size: 16,
                                    color: colorTexto,
                                  ),
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
