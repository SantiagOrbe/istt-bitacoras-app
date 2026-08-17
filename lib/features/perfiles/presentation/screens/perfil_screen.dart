import 'package:bitacoras_app/features/inicio/presentation/widgets/inicio_app_bar.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../domain/models/perfil_model.dart';
import '../widgets/perfil_header_card.dart';
import '../widgets/perfil_info_tile.dart';

class PerfilScreen extends StatelessWidget {
  final UsuarioModel currentUser;

  const PerfilScreen({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final profile = PerfilModel.fromUser(currentUser);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: currentUser,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del Perfil
            PerfilHeaderCard(user: profile.user),
            
            AppSizes.gapV24,

            // Sección de detalles
            Text(
              'Información Académica y Personal',
              style: AppTextStyles.bodyBold.copyWith(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            AppSizes.gapV12,

            PerfilInfoTile(
              icon: Icons.badge_outlined,
              title: 'Cédula de Identidad',
              value: profile.cedula,
            ),
            PerfilInfoTile(
              icon: Icons.school_outlined,
              title: 'Matrícula',
              value: profile.matricula,
            ),
            PerfilInfoTile(
              icon: Icons.email_outlined,
              title: 'Correo Electrónico',
              value: profile.user.email,
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
          ],
        ),
      ),
    );
  }
}