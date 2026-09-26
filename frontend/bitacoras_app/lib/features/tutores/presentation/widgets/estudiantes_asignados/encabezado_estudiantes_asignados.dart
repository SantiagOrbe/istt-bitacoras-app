import 'package:bitacoras_app/features/tutores/tutores.dart';

class EncabezadoEstudiantesAsignados extends StatelessWidget {
  final String titulo;
  final int cantidad;

  const EncabezadoEstudiantesAsignados({
    super.key,
    required this.titulo,
    required this.cantidad,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: AppColores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Row(
          children: [
            const Icon(Icons.groups_outlined, color: AppColores.primary, size: 32),
            AppTamanos.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppEstiloTexto.heading),
                  AppTamanos.gapV4,
                  Text(
                    '$cantidad estudiante(s) asignado(s)',
                    style: AppEstiloTexto.body.copyWith(
                      color: AppColores.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
