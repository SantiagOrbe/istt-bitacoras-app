import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorEncabezadoSeccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Color color;

  const CoordinadorEncabezadoSeccion({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    this.color = AppColores.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InstitutionalGlowCard(
      accentColor: color,
      child: Padding(
        padding: const EdgeInsets.all(AppTamanos.lg),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icono, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppEstiloTexto.title),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
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
