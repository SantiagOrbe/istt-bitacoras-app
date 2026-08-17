import 'package:flutter/material.dart';

import '../../../domain/models/usuario_model.dart';
import 'titulo_seccion_tablero_widget.dart';
import 'saludo_card.dart';
import 'estado_card.dart';

class CuerpoTableroWidget extends StatelessWidget {

  final UsuarioModel user;
  final Widget child;

  const CuerpoTableroWidget({
    super.key,
    required this.user,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      padding: const EdgeInsets.all(20),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          SaludoCard(name: user.name, role: user.role,),

          const SizedBox(height:20),

          const EstadoCard(
          ),

          const SizedBox(height:30),

          const TituloSeccionTableroWidget(
            title: "Acciones rápidas",
          ),

          const SizedBox(height:15),

          child,

        ],
      ),
    );
  }
}