import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraDetailSummaryCard extends StatelessWidget {
  final CarreraModel career;
  final VoidCallback onEdit;
  final VoidCallback onOpenSemesters;
  final VoidCallback onToggleStatus;

  const CarreraDetailSummaryCard({
    super.key,
    required this.career,
    required this.onEdit,
    required this.onOpenSemesters,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTamanos.lg),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        border: Border.all(color: AppColores.outline),
        boxShadow: [
          BoxShadow(
            color: AppColores.shadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColores.secondary, AppColores.warning],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColores.secondary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_tree_rounded,
                  color: AppColores.surface,
                  size: 32,
                ),
              ),
              IconButton(
                tooltip: 'Editar carrera',
                icon: const Icon(Icons.edit_outlined),
                color: AppColores.primary,
                onPressed: onEdit,
              ),
            ],
          ),
          AppTamanos.gapV12,
          Text(
            career.name,
            style: AppEstiloTexto.heading.copyWith(
              color: AppColores.textPrimary,
            ),
          ),
          AppTamanos.gapV8,
          Text(
            '${career.shortName} • ${career.modality}',
            style: AppEstiloTexto.bodyMedium.copyWith(
              color: AppColores.secondary,
            ),
          ),
          AppTamanos.gapV8,
          Text(
            'ID: ${career.id}',
            style: AppEstiloTexto.caption.copyWith(
              color: AppColores.textSecondary,
            ),
          ),
          AppTamanos.gapV16,
          CarreraInfoRow(label: 'Código', value: career.code),
          AppTamanos.gapV16,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onOpenSemesters,
              icon: const Icon(Icons.layers_outlined),
              label: const Text('Semestres'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColores.primary,
                foregroundColor: AppColores.surface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                ),
              ),
            ),
          ),
          AppTamanos.gapV8,
          CarreraInfoRow(label: 'Sigla', value: career.shortName),
          AppTamanos.gapV8,
          CarreraInfoRow(label: 'Modalidad', value: career.modality),
          AppTamanos.gapV8,
          CarreraInfoRow(
            label: 'Semestres totales',
            value: career.totalSemesters.toString(),
          ),
          AppTamanos.gapV8,
          CarreraInfoRow(
            label: 'Estado',
            value: career.isActive ? 'Activa' : 'Inactiva',
          ),
          AppTamanos.gapV8,
          Text(
            career.description,
            style: AppEstiloTexto.body.copyWith(
              color: AppColores.textSecondary,
            ),
          ),
          AppTamanos.gapV16,
          FilledButton.icon(
            onPressed: onToggleStatus,
            icon: Icon(
              career.isActive
                  ? Icons.block_flipped
                  : Icons.check_circle_outline,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: career.isActive
                  ? AppColores.error
                  : AppColores.success,
            ),
            label: Text(
              career.isActive ? 'Desactivar carrera' : 'Activar carrera',
            ),
          ),
        ],
      ),
    );
  }
}

class CarreraInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const CarreraInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTamanos.md,
        vertical: AppTamanos.sm,
      ),
      decoration: BoxDecoration(
        color: AppColores.background,
        borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppEstiloTexto.bodyMedium),
          Text(
            value,
            style: AppEstiloTexto.bodyBold.copyWith(color: AppColores.primary),
          ),
        ],
      ),
    );
  }
}
