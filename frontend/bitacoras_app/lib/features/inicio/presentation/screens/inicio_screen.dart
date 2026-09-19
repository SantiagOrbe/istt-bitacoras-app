import 'package:bitacoras_app/features/admin/domain/models/item_menu_model.dart';
import 'package:bitacoras_app/features/inicio/presentation/widgets/drawer/opciones_drawer_factory.dart';
import 'package:bitacoras_app/features/screens.dart';
import 'package:bitacoras_app/shared/exports.dart';
import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';

//Pantalla de inicio que filtra por Roles y muestra la pantalla de inicio según Rol

class InicioScreen extends StatelessWidget {
  final UsuarioModel user;
  final List<AccionRapidaModel> actions;
  final List<SeccionMenuModel>? drawerSections;
  final RegistroAsistenciaModel? todayRecord;
  final bool isAttendanceLoading;

  const InicioScreen({
    super.key,
    required this.user,
    required this.actions,
    this.drawerSections,
    this.todayRecord,
    this.isAttendanceLoading = false,
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
              EstadoCard(
                todayRecord: todayRecord,
                isLoading: isAttendanceLoading,
              ),
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