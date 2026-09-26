import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorTarjetaEstudiante extends StatelessWidget {
  final CoordinadorEstudianteModel estudiante;

  const CoordinadorTarjetaEstudiante({
    super.key,
    required this.estudiante,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColores.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColores.outline),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
              Icons.person_outline,
              color: AppColores.primary,
              size: 18,
            ),
          ),
          title: Text(
            estudiante.nombre,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColores.textPrimary,
            ),
          ),
          subtitle: Text(
            estudiante.correo.isEmpty ? 'Sin correo registrado' : estudiante.correo,
            style: const TextStyle(
              color: AppColores.textSecondary,
              fontSize: 12,
            ),
          ),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CoordinadorPildoraInfo(
                  etiqueta: 'Cédula',
                  valor: estudiante.cedula,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Matrícula',
                  valor: estudiante.matricula,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Teléfono',
                  valor: estudiante.telefono,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Usuario',
                  valor: estudiante.username,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Estado',
                  valor: estudiante.estaActivo ? 'Activo' : 'Inactivo',
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Carrera',
                  valor: estudiante.carrera,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Semestre',
                  valor: estudiante.semestre,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Paralelo',
                  valor: estudiante.paralelo,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Empresa',
                  valor: estudiante.empresa.isEmpty ? 'Sin empresa' : estudiante.empresa,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Tutor',
                  valor: estudiante.tutorAcademico.isEmpty ? 'Sin tutor' : estudiante.tutorAcademico,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Cédula tutor académico',
                  valor: estudiante.tutorAcademicoCedula,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Tutor empresarial',
                  valor: estudiante.tutorEmpresarial,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Cédula tutor empresarial',
                  valor: estudiante.tutorEmpresarialCedula,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Cargo tutor empresarial',
                  valor: estudiante.tutorEmpresarialCargo,
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Horas acumuladas',
                  valor: estudiante.horasAcumuladas.toStringAsFixed(2),
                ),
                CoordinadorPildoraInfo(
                  etiqueta: 'Horas requeridas',
                  valor: estudiante.horasRequeridas.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
