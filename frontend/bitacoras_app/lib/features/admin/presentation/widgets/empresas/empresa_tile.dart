import 'package:bitacoras_app/features/admin/admin.dart';

class EmpresaListadoHeader extends StatelessWidget {
  final int total;
  final ValueChanged<String> alBuscar;
  final bool? filtroEstado;
  final ValueChanged<bool?> alFiltrar;

  const EmpresaListadoHeader({
    super.key,
    required this.total,
    required this.alBuscar,
    required this.filtroEstado,
    required this.alFiltrar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
        AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.warning],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: AppColors.surface,
                ),
              ),
              AppSizes.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Empresas e instituciones',
                      style: AppTextStyles.title,
                    ),
                    Text(
                      'Lugares disponibles para prácticas',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$total',
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.primary,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          AppSizes.gapV16,
          BarraBusquedaPrisma(
            etiqueta: 'Buscar empresas',
            textoSugerido: 'Nombre o correo institucional',
            textoAyuda: 'Directorio de instituciones',
            alCambiar: alBuscar,
          ),
          AppSizes.gapV12,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                EmpresaFiltroChip(
                  label: 'Todas',
                  selected: filtroEstado == null,
                  onSelected: (_) => alFiltrar(null),
                ),
                EmpresaFiltroChip(
                  label: 'Activas',
                  selected: filtroEstado == false,
                  onSelected: (_) => alFiltrar(false),
                ),
                EmpresaFiltroChip(
                  label: 'Inactivas',
                  selected: filtroEstado == true,
                  onSelected: (_) => alFiltrar(true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmpresaFiltroChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const EmpresaFiltroChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        backgroundColor: AppColors.surface,
        labelStyle: AppTextStyles.body.copyWith(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outline,
        ),
      ),
    );
  }
}

class EmpresaListadoVacio extends StatelessWidget {
  final bool? filtroEstado;

  const EmpresaListadoVacio({super.key, required this.filtroEstado});

  @override
  Widget build(BuildContext context) {
    final mensaje = filtroEstado == true
        ? 'No hay empresas inactivas.'
        : filtroEstado == false
        ? 'No hay empresas activas.'
        : 'No hay empresas registradas.';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.business_outlined,
              size: 36,
              color: AppColors.textDisabled,
            ),
            AppSizes.gapV8,
            Text(
              mensaje,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmpresaTile extends StatelessWidget {
  final EmpresaModel empresa;
  final VoidCallback alAbrir;

  const EmpresaTile({super.key, required this.empresa, required this.alAbrir});

  @override
  Widget build(BuildContext context) {
    final colorEstado = empresa.isActive ? AppColors.success : AppColors.error;

    return InkWell(
      onTap: alAbrir,
      hoverColor: AppColors.secondary.withValues(alpha: 0.06),
      splashColor: AppColors.secondary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.14),
              child: const Icon(
                Icons.business_outlined,
                color: AppColors.secondary,
              ),
            ),
            AppSizes.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(empresa.name, style: AppTextStyles.bodyBold),
                  Text(empresa.email, style: AppTextStyles.caption),
                  Text(
                    empresa.phone,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: empresa.isActive
                    ? AppColors.successSoft
                    : AppColors.errorSoft,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: colorEstado.withValues(alpha: 0.35)),
              ),
              child: Text(
                empresa.isActive ? 'Activa' : 'Inactiva',
                style: AppTextStyles.caption.copyWith(
                  color: colorEstado,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AppSizes.gapH8,
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
