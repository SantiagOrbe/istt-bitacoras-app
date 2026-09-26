import 'package:bitacoras_app/features/tutores/tutores.dart';

class ListaTutoriadosSeguimiento extends StatelessWidget {
  final bool isLoading;
  final List<EstudianteAsignadoModel> items;
  final void Function(EstudianteAsignadoModel) onOpen;

  const ListaTutoriadosSeguimiento({
    super.key,
    required this.isLoading,
    required this.items,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColores.primary));
    }
    if (items.isEmpty) {
      return Center(child: Text('No hay tutoriados asignados.', style: AppEstiloTexto.body));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SeguimientoEstudianteCard(
          item: items[i],
          onTap: () => onOpen(items[i]),
        ),
      ),
    );
  }
}
