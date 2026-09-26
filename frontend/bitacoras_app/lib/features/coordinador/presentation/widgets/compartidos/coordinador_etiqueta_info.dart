import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorEtiquetaInfo extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final Color color;

  const CoordinadorEtiquetaInfo({
    super.key,
    required this.etiqueta,
    required this.valor,
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
        '$etiqueta: $valor',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
