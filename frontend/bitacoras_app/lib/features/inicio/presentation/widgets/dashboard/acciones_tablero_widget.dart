import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bitacoras_app/config/constants/app_colors.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isNarrow ? 0.82 : 1.05,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];

            return AccesoRapidoCard(
              title: action.title,
              subtitle: action.subtitle,
              icon: action.icon,
              onTap: action.route != null
                  ? () => context.push(action.route!)
                  : action.onTap,
              color: action.iconBackgroundColor ?? AppColors.primary,
              enabled: action.enabled,
            );
          },
        );
      },
    );
  }
}