import '../exports.dart';


class TarjetaResumenPrisma extends StatefulWidget {
  final String indice;
  final String estado;
  final String titulo;
  final String descripcion;
  final String metadato;
  final VoidCallback? alAbrir;
  final bool estadoActivo;

  const TarjetaResumenPrisma({
    super.key,
    required this.indice,
    required this.estado,
    required this.titulo,
    required this.descripcion,
    required this.metadato,
    this.alAbrir,
    this.estadoActivo = true,
  });

  @override
  State<TarjetaResumenPrisma> createState() => _TarjetaResumenPrismaState();
}

class _TarjetaResumenPrismaState extends State<TarjetaResumenPrisma> {
  bool _estaSobre = false;

  @override
  Widget build(BuildContext context) {
    final colorEstado = widget.estadoActivo
        ? AppColores.success
        : AppColores.textDisabled;

    return MouseRegion(
      onEnter: (_) => setState(() => _estaSobre = true),
      onExit: (_) => setState(() => _estaSobre = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _estaSobre ? -1 : 0, 0),
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
        decoration: BoxDecoration(
          color: AppColores.surface,
          border: Border.all(
            color: _estaSobre
                ? AppColores.primary.withValues(alpha: 0.45)
                : AppColores.outline,
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: _estaSobre
              ? [
                  BoxShadow(
                    color: AppColores.shadow,
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColores.primary, AppColores.secondary],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.indice.toUpperCase(),
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorEstado.withValues(alpha: 0.1),
                        border: Border.all(
                          color: colorEstado.withValues(alpha: 0.35),
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: colorEstado,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.estado.toUpperCase(),
                            style: AppEstiloTexto.caption.copyWith(
                              color: AppColores.textPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  widget.titulo,
                  style: AppEstiloTexto.title.copyWith(
                    fontSize: 21,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.descripcion,
                  style: AppEstiloTexto.body.copyWith(
                    color: AppColores.textSecondary,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColores.divider, height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.metadato.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: AppEstiloTexto.caption.copyWith(
                          color: AppColores.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: widget.alAbrir,
                      iconAlignment: IconAlignment.end,
                      icon: AnimatedSlide(
                        duration: const Duration(milliseconds: 220),
                        offset: _estaSobre ? const Offset(0.2, 0) : Offset.zero,
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                        ),
                      ),
                      label: const Text('Abrir'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColores.primary,
                        padding: EdgeInsets.zero,
                        textStyle: AppEstiloTexto.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
