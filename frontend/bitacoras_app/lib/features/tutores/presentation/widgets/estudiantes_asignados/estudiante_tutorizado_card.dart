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
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: InstitutionalGlowCard(
        accentColor: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      student.initials,
                      style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: AppTextStyles.bodyBold),
                        Text(student.careerName ?? 'Sin carrera', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      item.status,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppSizes.gapH8,
                  IconButton(
                    onPressed: widget.onRecordsTap ??
                        () => setState(() => _isExpanded = !_isExpanded),
                    icon: Icon(
                        _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                            : Icons.check_rounded,
                    ),
                    color: AppColors.primary,
                    tooltip: widget.onRecordsTap != null
                      ? 'Ver registros del estudiante'
                      : _isExpanded
                        ? 'Ocultar datos'
                        : 'Mostrar datos completos',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              AppSizes.gapV12,
              const Divider(height: 1),
              AppSizes.gapV12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Empresa: ${student.company ?? 'N/A'}',
                      style: AppTextStyles.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.totalHoursCompletedLabel}/${item.totalHoursRequiredLabel} hrs',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              AppSizes.gapV8,
              LinearProgressIndicator(value: item.progressPercentage, backgroundColor: AppColors.divider, color: AppColors.primary, minHeight: 6),
              if (_isExpanded) ...[
                AppSizes.gapV12,
                const Divider(height: 1),
                AppSizes.gapV12,
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
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          AppSizes.gapH8,
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
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