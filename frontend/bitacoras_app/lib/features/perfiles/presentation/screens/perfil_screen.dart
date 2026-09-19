import 'package:bitacoras_app/shared/exports.dart';
import '../../domain/models/perfil_model.dart';
import '../widgets/perfil_header_card.dart';
import '../widgets/perfil_info_tile.dart';

class PerfilScreen extends StatelessWidget {
  final UsuarioModel currentUser;

  const PerfilScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final profile = PerfilModel.fromUser(currentUser);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: currentUser),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del Perfil
            PerfilHeaderCard(user: profile.user),

            AppSizes.gapV24,

            Text(
              currentUser.role == RolUsuarioModel.admin
                  ? 'Información del administrador'
                  : 'Información Académica y Personal',
              style: AppTextStyles.bodyBold.copyWith(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            AppSizes.gapV12,

            if (currentUser.role == RolUsuarioModel.admin) ...[
              PerfilInfoTile(
                icon: Icons.account_circle_outlined,
                title: 'Usuario',
                value: profile.user.username,
              ),
              PerfilInfoTile(
                icon: Icons.email_outlined,
                title: 'Correo electrónico',
                value: profile.user.email,
              ),
              PerfilInfoTile(
                icon: Icons.phone_outlined,
                title: 'Teléfono',
                value: profile.user.phone ?? 'No registrado',
              ),
              PerfilInfoTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Rol',
                value: profile.user.role.label,
              ),
              PerfilInfoTile(
                icon: Icons.verified_user_outlined,
                title: 'Estado de la cuenta',
                value: profile.user.isActive ? 'Activa' : 'Inactiva',
              ),
            ] else ..._profileDetails(profile),
          ],
        ),
      ),
    );
  }

  List<Widget> _profileDetails(PerfilModel profile) {
    final details = <Widget>[
      PerfilInfoTile(
        icon: Icons.badge_outlined,
        title: 'Cédula de Identidad',
        value: profile.cedula,
      ),
      PerfilInfoTile(
        icon: Icons.email_outlined,
        title: 'Correo Electrónico',
        value: profile.user.email,
      ),
    ];

    switch (currentUser.role) {
      case RolUsuarioModel.student:
        details.addAll([
          PerfilInfoTile(
            icon: Icons.business_center_outlined,
            title: 'Empresa asignada',
            value: profile.empresaAsignada,
          ),
          PerfilInfoTile(
            icon: Icons.person_outline,
            title: 'Tutor Académico',
            value: profile.tutorAcademico,
          ),
          PerfilInfoTile(
            icon: Icons.business_center_outlined,
            title: 'Tutor Empresarial',
            value: profile.tutorEmpresarial,
          ),
        ]);
      case RolUsuarioModel.academicTutor:
      case RolUsuarioModel.companyTutor:
        details.add(
          PerfilInfoTile(
            icon: Icons.business_center_outlined,
            title: 'Empresa asignada',
            value: profile.empresaAsignada,
          ),
        );
        if (currentUser.role == RolUsuarioModel.academicTutor) {
          details.add(
            PerfilInfoTile(
              icon: Icons.school_outlined,
              title: 'Carrera asignada',
              value: currentUser.careerName ?? 'No asignada',
            ),
          );
        }
      case RolUsuarioModel.practiceManager:
        details.add(
          PerfilInfoTile(
            icon: Icons.school_outlined,
            title: 'Carrera asignada',
            value: currentUser.careerName ?? 'No asignada',
          ),
        );
      case RolUsuarioModel.coordinator:
        details.add(
          PerfilInfoTile(
            icon: Icons.school_outlined,
            title: 'Carrera asignada',
            value: currentUser.careerName ?? 'No asignada',
          ),
        );
      case RolUsuarioModel.teacher:
      case RolUsuarioModel.admin:
        break;
    }

    return details;
  }
}
