import 'package:flutter/material.dart';

import '../../../../config/theme/app_text_styles.dart';

class WelcomeHeader extends StatelessWidget {
  final String name;
  final String role;
  final String greeting;

  const WelcomeHeader({
    super.key,
    required this.name,
    required this.role,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        CircleAvatar(
          radius: 32,
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
            size: 34,
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                greeting,
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 4),

              Text(
                name,
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  role,
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}