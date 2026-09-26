import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class TarjetaSemestreCarrera extends StatelessWidget {
  final CoordinadorSemestreModel semestre;
  final List<CoordinadorParaleloModel> paralelos;

  const TarjetaSemestreCarrera({
    super.key,
    required this.semestre,
    required this.paralelos,
  });

  @override
  Widget build(BuildContext context) {
    final semestreParalelos = paralelos
        .where((paralelo) => paralelo.semestreId == semestre.id)
        .toList();
    final practicasHabilitadas =
        semestre.estaActivo && semestre.horasPracticas > 0;

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
                    semestre.nombre,
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
                    semestre.nivel.isEmpty ? 'Nivel' : semestre.nivel,
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
              CoordinadorMensajeEstado(
                icono: practicasHabilitadas
                    ? Icons.check_circle_outline_rounded
                    : Icons.info_outline_rounded,
                texto: practicasHabilitadas
                    ? 'Este semestre está habilitado para realizar prácticas.'
                    : 'Este semestre no está habilitado para realizar prácticas.',
                detalle: semestre.horasPracticas > 0
                    ? '${semestre.horasPracticas} horas de prácticas configuradas.'
                    : 'No tiene horas de prácticas configuradas.',
                color: practicasHabilitadas
                    ? AppColores.success
                    : AppColores.textSecondary,
              ),
              const SizedBox(height: 12),
              if (semestreParalelos.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'No hay paralelos registrados para este semestre.',
                    style: AppEstiloTexto.body.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: semestreParalelos
                      .map((paralelo) => TarjetaParaleloCarrera(paralelo: paralelo))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
