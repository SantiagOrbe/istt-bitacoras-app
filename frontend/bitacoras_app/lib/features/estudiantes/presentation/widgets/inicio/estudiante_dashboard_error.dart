import 'package:bitacoras_app/shared/exports.dart';

class EstudianteDashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const EstudianteDashboardError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: AppColores.error, size: 42),
            AppTamanos.gapV12,
            Text(message, textAlign: TextAlign.center, style: AppEstiloTexto.body),
            AppTamanos.gapV12,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
