import '../../auth.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppLogo(size: 120),
        const SizedBox(height: 20),
        Text('Bitácoras IST Tena', style: AppTextStyles.heading),
        const SizedBox(height: 8),
        Text(
          'Inicia sesión para continuar',
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
