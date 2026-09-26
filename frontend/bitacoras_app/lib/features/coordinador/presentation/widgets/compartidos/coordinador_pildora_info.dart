import 'package:bitacoras_app/features/coordinador/coordinador.dart';

class CoordinadorPildoraInfo extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const CoordinadorPildoraInfo({
    super.key,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColores.infoSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$etiqueta: ${valor.isEmpty ? 'No registrado' : valor}',
        style: const TextStyle(
          color: AppColores.primary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
