import 'package:bitacoras_app/features/admin/domain/models/item_menu_model.dart';
import 'package:bitacoras_app/features/inicio/presentation/widgets/drawer/opciones_drawer_factory.dart';
import 'package:bitacoras_app/features/screens.dart';
import 'package:bitacoras_app/shared/exports.dart';


class InicioScreen extends StatelessWidget {
  final UsuarioModel user;
  final List<AccionRapidaModel> actions;
  final List<SeccionMenuModel>? drawerSections;

  const InicioScreen({
    super.key,
    required this.user,
    required this.actions, this.drawerSections,
  });

  @override
  Widget build(BuildContext context) {
    // Verificamos si el usuario actual tiene el rol de estudiante
    final bool isStudent = user.role == RolUsuarioModel.student;
    final sectionsToDisplay = drawerSections ?? OpcionesDrawerFactory.getSectionsForRole(user.role);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: InicioAppBar(
        user: user,
        showDrawerButton: true,
      ),
      drawer: InicioDrawer(user: user, sections: sectionsToDisplay),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // El saludo recibe el rol para personalizar su subtítulo
            SaludoCard(
              name: user.name,
              role: user.role,
            ),

            // Si es estudiante, mostramos la tarjeta de estado actual
            if (isStudent) ...[
              const SizedBox(height: 16),
              const EstadoCard(),
            ],

            const SizedBox(height: 24),

            // Título de la sección de accesos directos
            const TituloSeccionTableroWidget(
              title: "Acciones Rápidas",
            ),

            const SizedBox(height: 16),

            // El grid con las acciones específicas que provee cada Home
            AccionesTableroWidget(actions: actions),
          ],
        ),
      ),
    );
  }
}