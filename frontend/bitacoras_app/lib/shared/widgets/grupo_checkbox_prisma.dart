import '../exports.dart';


class OpcionCheckboxPrisma {
  final String etiqueta;
  final String? metadato;
  final bool seleccionado;

  const OpcionCheckboxPrisma({
    required this.etiqueta,
    this.metadato,
    this.seleccionado = false,
  });
}

class GrupoCheckboxPrisma extends StatelessWidget {
  final String titulo;
  final List<OpcionCheckboxPrisma> opciones;
  final ValueChanged<int>? alCambiar;

  const GrupoCheckboxPrisma({
    super.key,
    required this.titulo,
    required this.opciones,
    this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: AppColores.surface,
        border: Border.all(color: AppColores.outline),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo.toUpperCase(),
            style: AppEstiloTexto.caption.copyWith(
              color: AppColores.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(
            opciones.length,
            (indice) => _OpcionCheckbox(
              opcion: opciones[indice],
              alCambiar: alCambiar == null ? null : () => alCambiar!(indice),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpcionCheckbox extends StatelessWidget {
  final OpcionCheckboxPrisma opcion;
  final VoidCallback? alCambiar;

  const _OpcionCheckbox({required this.opcion, this.alCambiar});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alCambiar,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: opcion.seleccionado
                    ? AppColores.primary
                    : Colors.transparent,
                border: Border.all(
                  color: opcion.seleccionado
                      ? AppColores.primary
                      : AppColores.outline,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: opcion.seleccionado
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: AppColores.surface,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                opcion.etiqueta,
                style: AppEstiloTexto.body.copyWith(fontSize: 14),
              ),
            ),
            if (opcion.metadato != null)
              Text(
                opcion.metadato!,
                style: AppEstiloTexto.caption.copyWith(
                  color: AppColores.textSecondary,
                  fontSize: 11,
                  letterSpacing: 1.1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
