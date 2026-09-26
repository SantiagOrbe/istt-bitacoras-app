import 'package:bitacoras_app/features/admin/admin.dart';

class BotonConfigurarCarrerasPeriodo extends StatelessWidget {
  final PeriodoModel periodo;
  final VoidCallback onPressed;

  const BotonConfigurarCarrerasPeriodo({
    super.key,
    required this.periodo,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColores.primary,
          side: const BorderSide(color: AppColores.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTamanos.md,
            vertical: AppTamanos.sm,
          ),
          alignment: Alignment.centerLeft,
        ),
        icon: const Icon(Icons.tune_rounded),
        label: Text(
          'Configurar carreras de ${periodo.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
