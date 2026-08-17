import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/accion_rapida_model.dart';
import 'acceso_rapido_card.dart';

class AccionesTableroWidget extends StatelessWidget {
  final List<AccionRapidaModel> actions;

  const AccionesTableroWidget({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.05, 
      ),
      itemBuilder: (context, index) {
        final action = actions[index];

        // Definimos una paleta de colores basada exactamente en tu captura de Figma
        Color cardColor;
        switch (index) {
          case 0:
            cardColor = const Color(0xFF2E7D32); 
            break;
          case 1:
            cardColor = const Color(0xFFD35400);; 
            break;
          case 2:
            cardColor = const Color(0xFF00695C); 
            break;
          case 3:
            cardColor = const Color(0xFF0F4C81); 
            break;
          default:
            cardColor = const Color(0xFF0F4C81);
        }

        return AccesoRapidoCard(
          title: action.title,
          icon: action.icon,
          onTap: action.route != null ? () => context.push(action.route!) : action.onTap,
          color: cardColor,
        );
      },
    );
  }
}