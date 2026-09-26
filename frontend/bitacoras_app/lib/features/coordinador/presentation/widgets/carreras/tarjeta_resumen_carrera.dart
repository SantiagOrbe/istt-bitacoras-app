import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class TarjetaResumenCarrera extends StatelessWidget {
  final CoordinadorCarreraModel carrera;
  final List<CoordinadorSemestreModel> semestres;
  final List<CoordinadorParaleloModel> paralelos;

  const TarjetaResumenCarrera({
    super.key,
    required this.carrera,
    required this.semestres,
    required this.paralelos,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColores.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_tree_rounded,
                    color: AppColores.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Carrera asignada', style: AppEstiloTexto.caption),
                      const SizedBox(height: 4),
                      Text(
                        carrera.nombre.isNotEmpty
                            ? carrera.nombre
                            : 'Carrera sin asignar',
                        style: AppEstiloTexto.heading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CoordinadorEtiquetaInfo(
                  etiqueta: 'Semestres',
                  valor: semestres.length.toString(),
                  color: AppColores.primary,
                ),
                CoordinadorEtiquetaInfo(
                  etiqueta: 'Paralelos',
                  valor: paralelos.length.toString(),
                  color: AppColores.secondary,
                ),
                CoordinadorEtiquetaInfo(
                  etiqueta: 'Estado',
                  valor: 'Activa',
                  color: AppColores.success,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Estructura académica de la carrera.',
              style: AppEstiloTexto.body.copyWith(
                color: AppColores.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
