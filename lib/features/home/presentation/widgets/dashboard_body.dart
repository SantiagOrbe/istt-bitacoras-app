import 'package:flutter/material.dart';

import '../../domain/models/user_model.dart';
import 'dashboard_section_title.dart';
import 'greeting_card.dart';
import 'status_card.dart';

class DashboardBody extends StatelessWidget {

  final UserModel user;
  final Widget child;

  const DashboardBody({
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

          GreetingCard(name: user.fullName, role: user.role,),

          const SizedBox(height:20),

          const StatusCard(
          ),

          const SizedBox(height:30),

          const DashboardSectionTitle(
            title: "Acciones rápidas",
          ),

          const SizedBox(height:15),

          child,

        ],
      ),
    );
  }
}