import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';
import 'router.dart';

class BitacorasApp extends StatelessWidget {
  const BitacorasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bitácoras IST Tena',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      routerConfig: AppRouter.router,
    );
  }
}