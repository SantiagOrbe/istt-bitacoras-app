import 'package:bitacoras_app/app/routes/app_router.dart';
import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
import 'package:provider/provider.dart';

//Función Main de Flutter Usada para correr toda la App.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AsistenciaProvider())],
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F4C81)),
        useMaterial3: true,
      ),
    );
  }
}
