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
      accentColor: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
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
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(
                  Icons.notes_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              AppSizes.gapH8,
              Expanded(
                child: Text(
                  'Detalle su actividad ${canRemove ? "#${index + 1}" : ""}',
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Eliminar actividad',
                ),
            ],
          ),
          AppSizes.gapV8,
          TextField(
            controller: controller,
            maxLines: 4,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Descripción de la actividad',
              labelStyle: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              hintText:
                  'Describa detalladamente las tareas realizadas, herramientas utilizadas y resultados obtenidos...',
              hintStyle: AppTextStyles.caption.copyWith(
                color: AppColors.textHint,
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.all(AppSizes.sm + 4),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(
                  color: AppColors.primary,
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
