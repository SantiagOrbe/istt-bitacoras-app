  import 'package:flutter/material.dart';

  import '../../../../../config/theme/app_estilo_texto.dart';

  class TituloSeccionTableroWidget extends StatelessWidget {

    final String title;

    const TituloSeccionTableroWidget({
      super.key,
      required this.title,
    });

    @override
    Widget build(BuildContext context) {
      return Text(
        title,
        style: AppEstiloTexto.title,
      );
    }
  }