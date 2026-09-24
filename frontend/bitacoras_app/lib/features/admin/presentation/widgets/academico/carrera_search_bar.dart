import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const CarreraSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Buscar carrera...',
  });

  @override
  Widget build(BuildContext context) {
    return BarraBusquedaPrisma(
      etiqueta: 'Buscar carreras',
      textoSugerido: hintText,
      textoAyuda: 'Catálogo académico',
      alCambiar: onChanged,
    );
  }
}
