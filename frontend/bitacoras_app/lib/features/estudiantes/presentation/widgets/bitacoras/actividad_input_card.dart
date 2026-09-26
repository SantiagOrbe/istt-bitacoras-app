import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

class ActividadInputCard extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final VoidCallback? onRemove;
  final bool canRemove;

  const ActividadInputCard({
    super.key,
    required this.index,
    required this.controller,
    this.onRemove,
    this.canRemove = false,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColores.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                ),
                child: const Icon(
                  Icons.notes_rounded,
                  color: AppColores.primary,
                  size: 18,
                ),
              ),
              AppTamanos.gapH8,
              Expanded(
                child: Text(
                  'Detalle su actividad ${canRemove ? "#${index + 1}" : ""}',
                  style: AppEstiloTexto.bodyBold.copyWith(
                    fontSize: 13,
                    color: AppColores.textPrimary,
                  ),
                ),
              ),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColores.error,
                    size: 20,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Eliminar actividad',
                ),
            ],
          ),
          AppTamanos.gapV8,
          TextField(
            controller: controller,
            maxLines: 4,
            style: AppEstiloTexto.body.copyWith(
              fontSize: 14,
              color: AppColores.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Descripción de la actividad',
              labelStyle: AppEstiloTexto.caption.copyWith(
                color: AppColores.textSecondary,
              ),
              hintText:
                  'Describa detalladamente las tareas realizadas, herramientas utilizadas y resultados obtenidos...',
              hintStyle: AppEstiloTexto.caption.copyWith(
                color: AppColores.textHint,
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColores.background,
              contentPadding: const EdgeInsets.all(AppTamanos.sm + 4),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                borderSide: const BorderSide(color: AppColores.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                borderSide: const BorderSide(
                  color: AppColores.primary,
                  width: 1.5,
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
