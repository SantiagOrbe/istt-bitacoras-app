import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:bitacoras_app/shared/exports.dart';

class RegistroActividadList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final ValueChanged<int> onRemove;

  const RegistroActividadList({
    super.key,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controllers.length,
      separatorBuilder: (context, index) => AppSizes.gapV16,
      itemBuilder: (context, index) {
        return ActividadInputCard(
          index: index,
          controller: controllers[index],
          canRemove: controllers.length > 1,
          onRemove: () => onRemove(index),
        );
      },
    );
  }
}
