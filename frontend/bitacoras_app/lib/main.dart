import 'package:bitacoras_app/app/auth_session.dart';
import 'package:bitacoras_app/app/routes/app_router.dart';
import 'package:bitacoras_app/app/providers.dart';
import 'package:bitacoras_app/config/theme/app_theme.dart';
import 'package:bitacoras_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Función Main de Flutter Usada para correr toda la App.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const BitacorasApp());
}

class BitacorasApp extends StatelessWidget {
  const BitacorasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: _SessionRestorer(
        child: MaterialApp.router(
          title: 'IST Tena Prácticas',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          theme: AppTheme.lightTheme,
        ),
      ),
    );
  }
}

class _SessionRestorer extends StatefulWidget {
  final Widget child;

  const _SessionRestorer({required this.child});

  @override
  State<_SessionRestorer> createState() => _SessionRestorerState();
}

class _SessionRestorerState extends State<_SessionRestorer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authRepository = context.read<IAuthRepository>();
      final session = context.read<AuthSession>();
      try {
        final user = await authRepository.getCurrentUser();
        if (!mounted) return;
        session.restoreUser(user);
      } catch (_) {
        if (!mounted) return;
        session.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
