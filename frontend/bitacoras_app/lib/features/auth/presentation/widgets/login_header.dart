import 'package:bitacoras_app/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';


class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [

        AppLogo(size: 120),

        SizedBox(height: 20),
    
        Text(
          'Bitácoras IST Tena',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 8),

        Text(
          'Inicia sesión para continuar',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}