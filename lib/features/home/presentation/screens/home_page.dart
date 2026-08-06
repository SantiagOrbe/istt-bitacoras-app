import 'package:bitacoras_app/features/screens.dart';
import 'package:bitacoras_app/shared/exports.dart';


class HomePage extends StatelessWidget {
  final UserModel user;
  final List<QuickAction> actions;

  const HomePage({
    super.key,
    required this.user,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Verificamos si el usuario actual tiene el rol de estudiante
    final bool isStudent = user.role == UserRole.student;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: HomeAppBar(user: user),
      drawer: HomeDrawer(user: user),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // El saludo recibe el rol para personalizar su subtítulo
            GreetingCard(
              name: user.fullName,
              role: user.role,
            ),

            // Si es estudiante, mostramos la tarjeta de estado actual
            if (isStudent) ...[
              const SizedBox(height: 16),
              const StatusCard(),
            ],

            const SizedBox(height: 24),

            // Título de la sección de accesos directos
            const DashboardSectionTitle(
              title: "Acciones Rápidas",
            ),

            const SizedBox(height: 16),

            // El grid con las acciones específicas que provee cada Home
            DashboardActions(actions: actions),
          ],
        ),
      ),
    );
  }
}