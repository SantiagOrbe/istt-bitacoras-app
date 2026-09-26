import 'package:bitacoras_app/features/tutores/tutores.dart';

class ListaRegistrosSeguimiento extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<RegistroPracticaModel> logs;
  final Future<void> Function() onRefresh;
  final Future<void> Function(RegistroPracticaModel log) onToggleStatus;
  final Future<void> Function(RegistroPracticaModel log) onEdit;

  const ListaRegistrosSeguimiento({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.logs,
    required this.onRefresh,
    required this.onToggleStatus,
    required this.onEdit,
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
            accentColor: log.isActive ? AppColores.primary : AppColores.textSecondary,
            child: ListTile(
              title: Text(
                '${log.date} - ${log.entryTimeLabel}',
                style: AppEstiloTexto.bodyBold,
              ),
              subtitle: Text(
                log.activityDescription,
                style: AppEstiloTexto.caption,
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit(log);
                  }
                  if (value == 'toggle') {
                    onToggleStatus(log);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(log.isActive ? 'Desactivar' : 'Activar'),
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
