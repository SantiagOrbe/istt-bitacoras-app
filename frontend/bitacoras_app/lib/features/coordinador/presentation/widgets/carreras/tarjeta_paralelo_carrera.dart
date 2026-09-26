import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class TarjetaParaleloCarrera extends StatelessWidget {
  final CoordinadorParaleloModel paralelo;

  const TarjetaParaleloCarrera({
    super.key,
    required this.paralelo,
  });

  @override
  Widget build(BuildContext context) {
    final color = paralelo.estaActivo
        ? AppColores.success
        : AppColores.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Icon(
            paralelo.estaActivo
                ? Icons.check_circle_rounded
                : Icons.pause_circle_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paralelo ${paralelo.nombre}',
                  style: const TextStyle(
                    color: AppColores.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  paralelo.estaActivo
                      ? 'Este paralelo está habilitado para prácticas.'
                      : 'Este paralelo no está habilitado para prácticas.',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (paralelo.jornada.isNotEmpty)
            Text(
              paralelo.jornada,
              style: const TextStyle(
                color: AppColores.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
