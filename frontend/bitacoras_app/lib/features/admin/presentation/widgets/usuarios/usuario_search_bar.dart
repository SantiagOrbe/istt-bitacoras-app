import 'package:bitacoras_app/features/admin/admin.dart';

class UsuarioSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const UsuarioSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BarraBusquedaPrisma(
      etiqueta: 'Buscar usuarios',
      textoSugerido: 'Buscar por nombre, correo o cédula',
      textoAyuda: 'Directorio institucional',
      alCambiar: onChanged,
    );
  }
}
