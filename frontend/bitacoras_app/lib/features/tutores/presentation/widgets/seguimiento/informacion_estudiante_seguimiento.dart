import 'package:bitacoras_app/features/tutores/tutores.dart';

class InformacionEstudianteSeguimiento extends StatelessWidget {
  final EstudianteAsignadoModel item;

  const InformacionEstudianteSeguimiento({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final student = item.student;

    return ListView(
      children: [
        _InfoTile(
          icon: Icons.business_outlined,
          title: 'Empresa',
          value: student.company ?? 'Sin empresa',
        ),
        _InfoTile(
          icon: Icons.badge_outlined,
          title: 'Cédula',
          value: student.cedula ?? 'Sin registro',
        ),
        _InfoTile(
          icon: Icons.email_outlined,
          title: 'Correo electrónico',
          value: student.email,
        ),
        _InfoTile(
          icon: Icons.phone_outlined,
          title: 'Teléfono',
          value: student.phone ?? 'Sin registro',
        ),
        _InfoTile(
          icon: Icons.school_outlined,
          title: 'Carrera',
          value: student.careerName ?? 'Sin carrera',
        ),
        _InfoTile(
          icon: Icons.class_outlined,
          title: 'Semestre',
          value: student.semestreNombre ?? 'Sin semestre',
        ),
        _InfoTile(
          icon: Icons.person_outline,
          title: 'Tutor empresarial',
          value:
              '${item.companyTutorName} ${item.companyTutorPhone.isNotEmpty ? '(${item.companyTutorPhone})' : ''}',
        ),
        _InfoTile(
          icon: Icons.edit_note_outlined,
          title: 'Última actividad',
          value: item.lastActivityDescription ?? 'Sin actividad registrada',
        ),
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          title: 'Última fecha',
          value: item.lastActivityDate ?? 'Sin registro',
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTamanos.sm),
      child: InstitutionalGlowCard(
        accentColor: AppColores.secondary,
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
          child: Row(
            children: [
              Icon(icon, color: AppColores.primary, size: 22),
              AppTamanos.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppEstiloTexto.caption),
                    AppTamanos.gapV4,
                    Text(value, style: AppEstiloTexto.body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
