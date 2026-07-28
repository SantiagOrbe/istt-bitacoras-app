import 'package:flutter/material.dart';
import '../../models/quick_action.dart';
import 'quick_access_card.dart';

class DashboardActions extends StatelessWidget {
  final List<QuickAction> actions;

  const DashboardActions({
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
        childAspectRatio: 1.05, // Ajuste milimétrico para simular tu diseño cuadrado
      ),
      itemBuilder: (context, index) {
        final action = actions[index];

        // Definimos una paleta de colores basada exactamente en tu captura de Figma
        Color cardColor;
        switch (index) {
          case 0:
            cardColor = const Color(0xFFF1C40F); // Amarillo institucional para Registro de Entrada
            break;
          case 1:
            cardColor = const Color(0xFFBDC3C7); // Gris para Registro de Salida (deshabilitado al inicio)
            break;
          case 2:
            cardColor = const Color(0xFF27AE60); // Verde para el Historial
            break;
          case 3:
            cardColor = const Color(0xFF2980B9); // Azul para el Perfil
            break;
          default:
            cardColor = const Color(0xFF0F4C81);
        }

        // Si el botón es el de registrar salida (index 1), podemos simular que está deshabilitado temporalmente
        final bool isEnabled = index != 1;

        return QuickAccessCard(
          title: action.title,
          icon: action.icon,
          onTap: action.onTap,
          color: cardColor,
          enabled: isEnabled,
        );
      },
    );
  }
}