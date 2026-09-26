import 'package:bitacoras_app/features/admin/admin.dart';

class BarraGuardarAdmin extends StatelessWidget {
  final VoidCallback onSave;

  const BarraGuardarAdmin({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppTamanos.md),
        decoration: const BoxDecoration(
          color: AppColores.surface,
          border: Border(top: BorderSide(color: AppColores.divider)),
        ),
        child: BotonPrisma(
          texto: 'Guardar configuración',
          icono: Icons.save_rounded,
          alPresionar: onSave,
          anchoCompleto: true,
        ),
      ),
    );
  }
}
