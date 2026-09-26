import 'package:bitacoras_app/features/tutores/tutores.dart';


class EstudianteTutorizadoCard extends StatefulWidget {
  final EstudianteAsignadoModel item;
  final VoidCallback? onRecordsTap;

  const EstudianteTutorizadoCard({
    super.key,
    required this.item,
    this.onRecordsTap,
  });

  @override
  State<EstudianteTutorizadoCard> createState() => _EstudianteTutorizadoCardState();
}

class _EstudianteTutorizadoCardState extends State<EstudianteTutorizadoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final student = item.student;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTamanos.sm),
      child: InstitutionalGlowCard(
        accentColor: AppColores.primary,
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColores.primary.withValues(alpha: 0.1),
                    child: Text(
                      student.initials,
                      style: AppEstiloTexto.bodyBold.copyWith(color: AppColores.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: AppEstiloTexto.bodyBold),
                        Text(student.careerName ?? 'Sin carrera', style: AppEstiloTexto.caption),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColores.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      item.status,
                      style: AppEstiloTexto.caption.copyWith(
                        color: AppColores.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppTamanos.gapH8,
                  IconButton(
                    onPressed: widget.onRecordsTap ??
                        () => setState(() => _isExpanded = !_isExpanded),
                    icon: Icon(
                        _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                            : Icons.check_rounded,
                    ),
                    color: AppColores.primary,
                    tooltip: widget.onRecordsTap != null
                      ? 'Ver registros del estudiante'
                      : _isExpanded
                        ? 'Ocultar datos'
                        : 'Mostrar datos completos',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              AppTamanos.gapV12,
              const Divider(height: 1),
              AppTamanos.gapV12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Empresa: ${student.company ?? 'N/A'}',
                      style: AppEstiloTexto.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.totalHoursCompletedLabel}/${item.totalHoursRequiredLabel} hrs',
                    style: AppEstiloTexto.caption.copyWith(
                      color: AppColores.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              AppTamanos.gapV8,
              LinearProgressIndicator(value: item.progressPercentage, backgroundColor: AppColores.divider, color: AppColores.primary, minHeight: 6),
              if (_isExpanded) ...[
                AppTamanos.gapV12,
                const Divider(height: 1),
                AppTamanos.gapV12,
                _DetailRow(icon: Icons.badge_outlined, label: 'Cédula', value: student.cedula ?? 'Sin registro'),
                _DetailRow(icon: Icons.email_outlined, label: 'Correo', value: student.email),
                _DetailRow(icon: Icons.phone_outlined, label: 'Teléfono', value: student.phone ?? 'Sin registro'),
                _DetailRow(icon: Icons.school_outlined, label: 'Carrera', value: student.careerName ?? 'Sin carrera'),
                _DetailRow(icon: Icons.class_outlined, label: 'Semestre', value: student.semestreNombre ?? 'Sin semestre'),
                _DetailRow(icon: Icons.person_outline, label: 'Tutor empresarial', value: item.companyTutorName.isEmpty ? 'Sin registro' : item.companyTutorName),
                _DetailRow(icon: Icons.edit_note_outlined, label: 'Última actividad', value: item.lastActivityDescription ?? 'Sin actividad registrada'),
                _DetailRow(icon: Icons.calendar_today_outlined, label: 'Última fecha', value: item.lastActivityDate ?? 'Sin registro'),
                _DetailRow(icon: Icons.access_time_outlined, label: 'Última asistencia', value: item.lastAttendanceTime ?? 'Sin registro'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTamanos.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColores.primary),
          AppTamanos.gapH8,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppEstiloTexto.caption.copyWith(color: AppColores.textPrimary),
                children: [
                  TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}