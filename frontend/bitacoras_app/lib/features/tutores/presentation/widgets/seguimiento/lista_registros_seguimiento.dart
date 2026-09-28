import 'package:bitacoras_app/features/tutores/tutores.dart';

class ListaRegistrosSeguimiento extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<RegistroPracticaModel> logs;
  final Future<void> Function() onRefresh;

  const ListaRegistrosSeguimiento({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.logs,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColores.primary),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(errorMessage!),
        ),
      );
    }

    if (logs.isEmpty) {
      return Center(
        child: Text('Sin registros de práctica.', style: AppEstiloTexto.body),
      );
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: AppTamanos.sm),
          child: InstitutionalGlowCard(
            accentColor: log.isActive
                ? AppColores.primary
                : AppColores.textSecondary,
            child: Padding(
              padding: const EdgeInsets.all(AppTamanos.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColores.infoSoft,
                          borderRadius: BorderRadius.circular(
                            AppTamanos.radiusSm,
                          ),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColores.primary,
                          size: 19,
                        ),
                      ),
                      AppTamanos.gapH8,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FECHA',
                              style: AppEstiloTexto.caption.copyWith(
                                color: AppColores.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(log.date, style: AppEstiloTexto.bodyBold),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppTamanos.gapV12,
                  Row(
                    children: [
                      Expanded(
                        child: _HorarioRegistro(
                          label: 'ENTRADA',
                          time: log.entryTimeLabel,
                          icon: Icons.login_rounded,
                        ),
                      ),
                      AppTamanos.gapH8,
                      Expanded(
                        child: _HorarioRegistro(
                          label: 'SALIDA',
                          time: log.exitTimeLabel,
                          icon: Icons.logout_rounded,
                        ),
                      ),
                    ],
                  ),
                  AppTamanos.gapV12,
                  const Divider(height: 1, color: AppColores.divider),
                  AppTamanos.gapV12,
                  Text(
                    'ACTIVIDAD REALIZADA',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppTamanos.gapV4,
                  Text(
                    log.activityDescription.isEmpty
                        ? 'Sin descripción registrada.'
                        : log.activityDescription,
                    style: AppEstiloTexto.body,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HorarioRegistro extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;

  const _HorarioRegistro({
    required this.label,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTamanos.sm),
      decoration: BoxDecoration(
        color: AppColores.background,
        borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
        border: Border.all(color: AppColores.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColores.primary),
          AppTamanos.gapH8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppEstiloTexto.caption.copyWith(
                    color: AppColores.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(time, style: AppEstiloTexto.bodyBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
