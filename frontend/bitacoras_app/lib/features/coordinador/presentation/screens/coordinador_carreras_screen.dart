import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorCarrerasScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const CoordinadorCarrerasScreen({super.key, required this.currentUser});

  @override
  State<CoordinadorCarrerasScreen> createState() =>
      _CoordinadorCarrerasScreenState();
}

class _CoordinadorCarrerasScreenState extends State<CoordinadorCarrerasScreen> {
  late final CoordinadorConsultaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: context.read<ICoordinadorRepository>(),
    );
    _controller.cargarCarreras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.estaCargando) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (_controller.carreras.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No hay una carrera asignada para este coordinador.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }

          final carrera = _controller.carreras.first;
          final semestres = _controller.datosCarrera?.semestres ?? const [];
          final paralelos = _controller.datosCarrera?.paralelos ?? const [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              InstitutionalGlowCard(
                accentColor: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.10),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_tree_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Carrera asignada',
                                  style: AppTextStyles.caption,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  carrera.nombre.isNotEmpty
                                      ? carrera.nombre
                                      : 'Carrera sin asignar',
                                  style: AppTextStyles.heading,
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
                          _InfoTag(
                            label: 'Semestres',
                            value: semestres.length.toString(),
                            color: AppColors.primary,
                          ),
                          _InfoTag(
                            label: 'Paralelos',
                            value: paralelos.length.toString(),
                            color: AppColors.secondary,
                          ),
                          _InfoTag(
                            label: 'Estado',
                            value: 'Activa',
                            color: AppColors.success,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Estructura académica de la carrera.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...semestres.map((semestre) {
                final semestreParalelos = paralelos
                    .where((paralelo) => paralelo.semestreId == semestre.id)
                    .toList();
                final practicasHabilitadas =
                  semestre.estaActivo && semestre.horasPracticas > 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InstitutionalGlowCard(
                    accentColor: AppColors.primary,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: 2,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          AppSizes.md,
                          0,
                          AppSizes.md,
                          AppSizes.md,
                        ),
                        iconColor: AppColors.primary,
                        collapsedIconColor: AppColors.primary,
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                semestre.nombre,
                                style: AppTextStyles.bodyBold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.infoSoft,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                semestre.nivel.isEmpty
                                    ? 'Nivel'
                                    : semestre.nivel,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          _StatusMessage(
                            icon: practicasHabilitadas
                                ? Icons.check_circle_outline_rounded
                                : Icons.info_outline_rounded,
                            text: practicasHabilitadas
                                ? 'Este semestre está habilitado para realizar prácticas.'
                                : 'Este semestre no está habilitado para realizar prácticas.',
                            detail: semestre.horasPracticas > 0
                                ? '${semestre.horasPracticas} horas de prácticas configuradas.'
                                : 'No tiene horas de prácticas configuradas.',
                            color: practicasHabilitadas
                                ? AppColors.success
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 12),
                          if (semestreParalelos.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'No hay paralelos registrados para este semestre.',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: semestreParalelos
                                  .map((paralelo) {
                                    final color = paralelo.estaActivo
                                        ? AppColors.success
                                        : AppColors.textSecondary;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.07),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: color.withValues(alpha: 0.20),
                                        ),
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
                                                    color: AppColors.textPrimary,
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
                                                color: AppColors.textSecondary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoTag({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final IconData icon;
  final String text;
  final String detail;
  final Color color;

  const _StatusMessage({
    required this.icon,
    required this.text,
    required this.detail,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
