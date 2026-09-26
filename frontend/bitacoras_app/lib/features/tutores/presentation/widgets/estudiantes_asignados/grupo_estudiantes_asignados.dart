import 'package:bitacoras_app/features/tutores/tutores.dart';

class GrupoEstudiantesAsignados extends StatelessWidget {
  final String semestre;
  final Map<String, List<EstudianteAsignadoModel>> grupos;
  final bool isAcademic;

  const GrupoEstudiantesAsignados({
    super.key,
    required this.semestre,
    required this.grupos,
    required this.isAcademic,
  });

  @override
  Widget build(BuildContext context) {
    final cantidad = grupos.values.expand((items) => items).length;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTamanos.sm),
      child: InstitutionalGlowCard(
        accentColor: AppColores.primary,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            leading: const Icon(Icons.school_outlined, color: AppColores.primary),
            title: Text(semestre, style: AppEstiloTexto.bodyBold),
            trailing: Text(
              '$cantidad',
              style: AppEstiloTexto.bodyBold.copyWith(color: AppColores.primary),
            ),
            children: grupos.entries
                .map(
                  (grupo) => Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTamanos.md,
                      0,
                      AppTamanos.md,
                      AppTamanos.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(grupo.key, style: AppEstiloTexto.caption),
                        AppTamanos.gapV8,
                        ...grupo.value.map(
                          (item) => EstudianteTutorizadoCard(
                            item: item,
                            onRecordsTap: () => context.push(
                              isAcademic
                                  ? AppRoutes.seguimientoTutorAcademico
                                  : AppRoutes.seguimientoTutorEmpresarial,
                              extra: item,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
