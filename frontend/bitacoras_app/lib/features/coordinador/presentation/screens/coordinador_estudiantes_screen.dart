import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorEstudiantesScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const CoordinadorEstudiantesScreen({super.key, required this.currentUser});

  @override
  State<CoordinadorEstudiantesScreen> createState() =>
      _CoordinadorEstudiantesScreenState();
}

class _CoordinadorEstudiantesScreenState
    extends State<CoordinadorEstudiantesScreen> {
  late final CoordinadorConsultaController _controller;
  final Map<String, String?> _paralelosSeleccionados = {};

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: context.read<ICoordinadorRepository>(),
    );
    _controller.cargarEstudiantes();
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
          final estudiantesPorSemestre =
              <String, Map<String, List<CoordinadorEstudianteModel>>>{};
          for (final estudiante in _controller.estudiantes) {
            final semestre = estudiante.semestre.isEmpty
                ? 'Semestre sin asignar'
                : estudiante.semestre;
            final paralelo = estudiante.paralelo.isEmpty
                ? 'Paralelo sin asignar'
                : estudiante.paralelo;
            estudiantesPorSemestre.putIfAbsent(semestre, () => {});
            estudiantesPorSemestre[semestre]!
                .putIfAbsent(paralelo, () => [])
                .add(estudiante);
          }

          void seleccionarParalelo(String semestre, String paralelo) {
            setState(() {
              _paralelosSeleccionados[semestre] =
                  _paralelosSeleccionados[semestre] == paralelo
                      ? null
                      : paralelo;
            });
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              InstitutionalGlowCard(
                accentColor: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.groups_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estudiantes', style: AppTextStyles.title),
                            const SizedBox(height: 4),
                            Text(
                              _controller.datosCarrera?.carrera.isNotEmpty == true
                                  ? _controller.datosCarrera!.carrera
                                  : widget.currentUser.careerName ?? 'Mi carrera',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...estudiantesPorSemestre.entries.map(
                (semester) => Padding(
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
                                semester.key,
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
                                '${semester.value.values.expand((items) => items).length}',
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
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: semester.value.keys.map((parallel) {
                              final seleccionado =
                                  _paralelosSeleccionados[semester.key] ==
                                  parallel;
                              return _ParallelFilterChip(
                                label: parallel,
                                selected: seleccionado,
                                onPressed: () => seleccionarParalelo(
                                  semester.key,
                                  parallel,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          ...semester.value.entries
                              .where(
                                (parallel) =>
                                    _paralelosSeleccionados[semester.key] ==
                                        null ||
                                    _paralelosSeleccionados[semester.key] ==
                                        parallel.key,
                              )
                              .expand((parallel) {
                            return parallel.value.map((estudiante) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.outline,
                                  ),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    childrenPadding: const EdgeInsets.fromLTRB(
                                      12,
                                      0,
                                      12,
                                      12,
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
                                        Icons.person_outline,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                    ),
                                    title: Text(
                                      estudiante.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      estudiante.correo.isEmpty
                                          ? 'Sin correo registrado'
                                          : estudiante.correo,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    children: [
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                              _InfoPill(
                                                label: 'Cédula',
                                                value: estudiante.cedula,
                                              ),
                                              _InfoPill(
                                                label: 'Matrícula',
                                                value: estudiante.matricula,
                                              ),
                                              _InfoPill(
                                                label: 'Teléfono',
                                                value: estudiante.telefono,
                                              ),
                                              _InfoPill(
                                                label: 'Usuario',
                                                value: estudiante.username,
                                              ),
                                              _InfoPill(
                                                label: 'Estado',
                                                value: estudiante.estaActivo
                                                    ? 'Activo'
                                                    : 'Inactivo',
                                              ),
                                              _InfoPill(
                                                label: 'Carrera',
                                                value: estudiante.carrera,
                                              ),
                                              _InfoPill(
                                                label: 'Semestre',
                                                value: estudiante.semestre,
                                              ),
                                              _InfoPill(
                                                label: 'Paralelo',
                                                value: estudiante.paralelo,
                                              ),
                                              _InfoPill(
                                                label: 'Empresa',
                                                value: estudiante.empresa.isEmpty
                                                    ? 'Sin empresa'
                                                    : estudiante.empresa,
                                              ),
                                              _InfoPill(
                                                label: 'Tutor',
                                                value: estudiante.tutorAcademico.isEmpty
                                                    ? 'Sin tutor'
                                                    : estudiante.tutorAcademico,
                                              ),
                                              _InfoPill(
                                                label: 'Cédula tutor académico',
                                                value: estudiante.tutorAcademicoCedula,
                                              ),
                                              _InfoPill(
                                                label: 'Tutor empresarial',
                                                value: estudiante.tutorEmpresarial,
                                              ),
                                              _InfoPill(
                                                label: 'Cédula tutor empresarial',
                                                value: estudiante.tutorEmpresarialCedula,
                                              ),
                                              _InfoPill(
                                                label: 'Cargo tutor empresarial',
                                                value: estudiante.tutorEmpresarialCargo,
                                              ),
                                              _InfoPill(
                                                label: 'Horas acumuladas',
                                                value: estudiante.horasAcumuladas
                                                    .toStringAsFixed(2),
                                              ),
                                              _InfoPill(
                                                label: 'Horas requeridas',
                                                value: estudiante.horasRequeridas
                                                    .toString(),
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;

  const _InfoPill({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.infoSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: ${value.isEmpty ? 'No registrado' : value}',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ParallelFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _ParallelFilterChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Material(
      color: selected ? AppColors.infoSoft : AppColors.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.outline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check_rounded, size: 15, color: AppColors.primary),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
