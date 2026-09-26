import 'package:bitacoras_app/features/admin/admin.dart';

class CabeceraListadoEmpresas extends StatelessWidget {
  final int total;
  final ValueChanged<String> alBuscar;
  final bool? filtroEstado;
  final ValueChanged<bool?> alFiltrar;

  const CabeceraListadoEmpresas({
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
        AppTamanos.md,
        AppTamanos.md,
        AppTamanos.md,
        AppTamanos.sm,
      ),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
        border: Border.all(color: AppColores.outline),
        boxShadow: [
          BoxShadow(
            color: AppColores.shadow,
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
                    colors: [AppColores.secondary, AppColores.warning],
                  ),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: AppColores.surface,
                ),
              ),
              AppTamanos.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Empresas e instituciones',
                      style: AppEstiloTexto.title,
                    ),
                    Text(
                      'Lugares disponibles para prácticas',
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$total',
                style: AppEstiloTexto.heading.copyWith(
                  color: AppColores.primary,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          AppTamanos.gapV16,
          BarraBusquedaPrisma(
            etiqueta: 'Buscar empresas',
            textoSugerido: 'Nombre o correo institucional',
            textoAyuda: 'Directorio de instituciones',
            alCambiar: alBuscar,
          ),
          AppTamanos.gapV12,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChipFiltroEmpresa(
                  label: 'Todas',
                  selected: filtroEstado == null,
                  onSelected: (_) => alFiltrar(null),
                ),
                ChipFiltroEmpresa(
                  label: 'Activas',
                  selected: filtroEstado == false,
                  onSelected: (_) => alFiltrar(false),
                ),
                ChipFiltroEmpresa(
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

class ChipFiltroEmpresa extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const ChipFiltroEmpresa({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppTamanos.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColores.primary.withValues(alpha: 0.12),
        backgroundColor: AppColores.surface,
        labelStyle: AppEstiloTexto.body.copyWith(
          color: selected ? AppColores.primary : AppColores.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? AppColores.primary : AppColores.outline,
        ),
      ),
    );
  }
}

class ListadoVacioEmpresa extends StatelessWidget {
  final bool? filtroEstado;

  const ListadoVacioEmpresa({super.key, required this.filtroEstado});

  @override
  Widget build(BuildContext context) {
    final mensaje = filtroEstado == true
        ? 'No hay empresas inactivas.'
        : filtroEstado == false
        ? 'No hay empresas activas.'
        : 'No hay empresas registradas.';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppTamanos.lg),
        decoration: BoxDecoration(
          color: AppColores.surface,
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          border: Border.all(color: AppColores.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.business_outlined,
              size: 36,
              color: AppColores.textDisabled,
            ),
            AppTamanos.gapV8,
            Text(
              mensaje,
              style: AppEstiloTexto.bodyMedium.copyWith(
                color: AppColores.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TarjetaEmpresa extends StatelessWidget {
  final EmpresaModel empresa;
  final VoidCallback alAbrir;

  const TarjetaEmpresa({
    super.key,
    required this.empresa,
    required this.alAbrir,
  });

  @override
  Widget build(BuildContext context) {
    final colorEstado = empresa.isActive
        ? AppColores.success
        : AppColores.error;

    return InkWell(
      onTap: alAbrir,
      hoverColor: AppColores.secondary.withValues(alpha: 0.06),
      splashColor: AppColores.secondary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppTamanos.md),
        decoration: BoxDecoration(
          color: AppColores.surface,
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          border: Border.all(color: AppColores.outline),
          boxShadow: [
            BoxShadow(
              color: AppColores.shadow,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColores.secondary.withValues(alpha: 0.14),
              child: const Icon(
                Icons.business_outlined,
                color: AppColores.secondary,
              ),
            ),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(empresa.name, style: AppEstiloTexto.bodyBold),
                  Text(empresa.email, style: AppEstiloTexto.caption),
                  Text(
                    empresa.phone,
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: empresa.isActive
                    ? AppColores.successSoft
                    : AppColores.errorSoft,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: colorEstado.withValues(alpha: 0.35)),
              ),
              child: Text(
                empresa.isActive ? 'Activa' : 'Inactiva',
                style: AppEstiloTexto.caption.copyWith(
                  color: colorEstado,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AppTamanos.gapH8,
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColores.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
