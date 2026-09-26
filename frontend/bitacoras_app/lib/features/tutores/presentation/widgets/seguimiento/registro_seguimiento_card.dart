import 'package:bitacoras_app/features/tutores/tutores.dart';

class RegistroSeguimientoCard extends StatelessWidget {
  final RegistroPracticaModel log;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const RegistroSeguimientoCard({
    super.key,
    required this.log,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = log.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTamanos.sm),
      child: InstitutionalGlowCard(
        accentColor: isActive ? AppColores.primary : AppColores.textSecondary,
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(log.studentName, style: AppEstiloTexto.bodyBold),
                        const SizedBox(height: 4),
                        Text(log.date, style: AppEstiloTexto.caption),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'toggle') onToggle();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text('Editar')])),
                      PopupMenuItem(value: 'toggle', child: Row(children: [Icon(isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18), const SizedBox(width: 8), Text(isActive ? 'Desactivar' : 'Activar')])),
                    ],
                  ),
                ],
              ),
              AppTamanos.gapV12,
              Text(log.activityDescription, style: AppEstiloTexto.body),
              AppTamanos.gapV12,
              Row(
                children: [
                  const Icon(Icons.access_time_filled, size: 14, color: AppColores.textSecondary),
                  const SizedBox(width: 6),
                  Text('${log.entryTimeLabel} - ${log.exitTimeLabel}', style: AppEstiloTexto.caption),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: log.status == 'Aprobado'
                          ? AppColores.successSoft
                          : isActive
                              ? AppColores.warningSoft
                              : AppColores.errorSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isActive ? log.status : 'Desactivado',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isActive ? (log.status == 'Aprobado' ? AppColores.success : AppColores.warning) : AppColores.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
