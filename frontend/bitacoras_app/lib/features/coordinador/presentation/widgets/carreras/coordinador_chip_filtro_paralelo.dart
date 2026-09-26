import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorChipFiltroParalelo extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onPressed;

  const CoordinadorChipFiltroParalelo({
    super.key,
    required this.etiqueta,
    required this.seleccionado,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = seleccionado ? AppColores.primary : AppColores.textSecondary;

    return Material(
      color: seleccionado ? AppColores.infoSoft : AppColores.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: seleccionado
                  ? AppColores.primary.withValues(alpha: 0.35)
                  : AppColores.outline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (seleccionado) ...[
                const Icon(
                  Icons.check_rounded,
                  size: 15,
                  color: AppColores.primary,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                etiqueta,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
