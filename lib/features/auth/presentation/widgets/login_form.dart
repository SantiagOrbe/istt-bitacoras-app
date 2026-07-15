import 'package:flutter/material.dart';

import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/inputs/custom_text_field.dart';
import '../../../../core/widgets/inputs/password_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final userController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CustomTextField(
          controller: userController,
          label: 'Correo Institucional',
          prefixIcon: Icons.email_outlined,
        ),

        SizedBox(height: 20),

        PasswordTextField(
          controller: passwordController,
        ),

        SizedBox(height: 30),

        CustomButton(
          text: 'Ingresar',
          onPressed: () {},
        ),
      ],
    );
  }
}