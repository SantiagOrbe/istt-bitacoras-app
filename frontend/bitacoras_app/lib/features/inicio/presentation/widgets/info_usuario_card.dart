import 'package:flutter/material.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../domain/models/usuario_model.dart';

class InfoUsuarioCard extends StatelessWidget {
  final UsuarioModel user;

  const InfoUsuarioCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            _item(
              Icons.email_outlined,
              "Correo",
              user.email,
            ),

            const Divider(),

            _item(
              Icons.business_outlined,
              "Empresa",
              user.company ?? "No asignada",
            ),  

          ],
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [

        Icon(icon),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: AppTextStyles.caption,
              ),

              Text(
                value,
                style: AppTextStyles.bodyBold,
              ),

            ],
          ),
        ),

      ],
    );
  }
}