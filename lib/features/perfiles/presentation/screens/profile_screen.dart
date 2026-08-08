import 'package:bitacoras_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../domain/models/profile_model.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_info_tile.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel currentUser;

  const ProfileScreen({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final profile = ProfileModel.fromUser(currentUser);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        user: currentUser,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del Perfil
            ProfileHeaderCard(user: profile.user),
            
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

            ProfileInfoTile(
              icon: Icons.badge_outlined,
              title: 'Cédula de Identidad',
              value: profile.cedula,
            ),
            ProfileInfoTile(
              icon: Icons.school_outlined,
              title: 'Matrícula',
              value: profile.matricula,
            ),
            ProfileInfoTile(
              icon: Icons.email_outlined,
              title: 'Correo Electrónico',
              value: profile.user.email,
            ),
            ProfileInfoTile(
              icon: Icons.person_outline,
              title: 'Tutor Académico',
              value: profile.tutorAcademico,
            ),
            ProfileInfoTile(
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