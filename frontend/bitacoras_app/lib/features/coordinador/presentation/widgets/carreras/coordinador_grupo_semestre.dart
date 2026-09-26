import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorGrupoSemestre extends StatelessWidget {
  final String nombreSemestre;
  final Map<String, List<CoordinadorEstudianteModel>> paralelos;
  final String? paraleloSeleccionado;
  final ValueChanged<String> onSeleccionarParalelo;

  const CoordinadorGrupoSemestre({
    super.key,
    required this.nombreSemestre,
    required this.paralelos,
    required this.paraleloSeleccionado,
    required this.onSeleccionarParalelo,
  });

  @override
  Widget build(BuildContext context) {
    final cantidadEstudiantes = paralelos.values
        .expand((lista) => lista)
        .length;

    final entradasFiltradas = paralelos.entries.where((entrada) {
      return paraleloSeleccionado == null || paraleloSeleccionado == entrada.key;
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InstitutionalGlowCard(
        accentColor: AppColores.primary,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: AppTamanos.md,
              vertical: 2,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(
              AppTamanos.md,
              0,
              AppTamanos.md,
              AppTamanos.md,
            ),
            iconColor: AppColores.primary,
            collapsedIconColor: AppColores.primary,
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColores.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 18,
                color: AppColores.primary,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    nombreSemestre,
                    style: AppEstiloTexto.bodyBold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColores.infoSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$cantidadEstudiantes',
                    style: const TextStyle(
                      color: AppColores.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: paralelos.keys.map((paralelo) {
                  final seleccionado = paraleloSeleccionado == paralelo;
                  return CoordinadorChipFiltroParalelo(
                    etiqueta: paralelo,
                    seleccionado: seleccionado,
                    onPressed: () => onSeleccionarParalelo(paralelo),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              ...entradasFiltradas.expand((entrada) {
                return entrada.value.map(
                  (estudiante) => CoordinadorTarjetaEstudiante(
                    estudiante: estudiante,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
