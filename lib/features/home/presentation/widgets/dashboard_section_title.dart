  import 'package:flutter/material.dart';

  import '../../../../config/theme/app_text_styles.dart';

  class DashboardSectionTitle extends StatelessWidget {

    final String title;

    const DashboardSectionTitle({
      super.key,
      required this.title,
    });

    @override
    Widget build(BuildContext context) {
      return Text(
        title,
        style: AppTextStyles.title,
      );
    }
  }