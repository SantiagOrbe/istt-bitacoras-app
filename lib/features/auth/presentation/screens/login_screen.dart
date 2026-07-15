import 'package:flutter/material.dart';

import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 30),

              LoginHeader(),

              SizedBox(height: 40),

              LoginForm(),

              SizedBox(height: 30),

              LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}