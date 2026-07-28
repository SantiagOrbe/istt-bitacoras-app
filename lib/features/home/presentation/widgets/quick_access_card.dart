import 'package:flutter/material.dart';

import '../../../../config/theme/app_text_styles.dart';

class QuickAccessCard extends StatelessWidget {

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  const QuickAccessCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enabled=true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor:
                  enabled ? color : Colors.grey.shade300,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),

            const SizedBox(height:15),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyBold.copyWith(
                color: enabled
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}