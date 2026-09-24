import 'package:bitacoras_app/features/estudiantes/estudiantes.dart';

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
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: user,
        showDrawerButton: true,
      ),
      drawer: InicioDrawer(user: user, sections: sectionsToDisplay),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // El saludo recibe el rol para personalizar su subtítulo
            SaludoCard(
              name: user.name,
              role: user.role,
              lightCard: user.role == RolUsuarioModel.practiceManager,
            ),

            // Si es estudiante, mostramos la tarjeta de estado actual
            if (isStudent) ...[
              AppSizes.gapV16,
              EstadoCard(
                todayRecord: todayRecord,
                isLoading: isAttendanceLoading,
              ),
            ],

            AppSizes.gapV24,

            // Título de la sección de accesos directos
            const TituloSeccionTableroWidget(
              title: "Acciones Rápidas",
            ),

            AppSizes.gapV16,

            // El grid con las acciones específicas que provee cada Home
            AccionesTableroWidget(actions: actions),
          ],
        ),
      ),
    );
  }
}