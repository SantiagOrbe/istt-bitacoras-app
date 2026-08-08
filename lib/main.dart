import 'package:bitacoras_app/app/routes/app_router.dart';
import 'package:bitacoras_app/features/estudiantes/presentation/controllers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: const BitacorasApp(),
    ),
  );
}

class BitacorasApp extends StatelessWidget {
  const BitacorasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IST Tena Prácticas',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F4C81),
        ),
        useMaterial3: true,
      ),
    );
  }
}